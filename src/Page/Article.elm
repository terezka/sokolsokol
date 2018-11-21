module Page.Article exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation as Nav
import Css
import Data.Article as Article
import Element.Button as Button
import Element.Color as Color
import Element.Image as Image
import Element.Text as Text
import Element.Util as Util
import File
import File.Select as Select
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Skeleton as Skeleton
import Ports
import Session
import Task


type alias Model =
    { id : Article.Id
    , editing : Maybe Article.Article
    }


init : Session.Data -> String -> ( Model, Cmd Msg, Session.Data )
init session id =
    ( { id = id, editing = Nothing }
    , Cmd.none
    , session
    )


type Msg
    = Toggle
    | Pick
    | Remove
    | GotFiles File.File (List File.File)
    | GotFileUrl String String
    | GotFileDownloadUrl Encode.Value
    | GotArticle Encode.Value


update : Nav.Key -> Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update key session msg model =
    case msg of
        Pick ->
            ( model, Select.files [ "image/*" ] GotFiles, session )

        Remove ->
            case Session.getArticle model.id session of
                Just article ->
                    ( model
                    , Cmd.none
                    , Session.setArticle (Article.setCover Nothing article) session
                    )

                Nothing ->
                    ( model, Cmd.none, session )

        GotFiles file files ->
            ( model
            , Task.perform (GotFileUrl (File.name file)) (File.toUrl file)
            , session
            )

        GotFileUrl name url ->
            ( model
            , Ports.uploadImage <|
                Encode.object
                    [ ( "name", Encode.string name )
                    , ( "url", Encode.string url )
                    ]
            , session
            )

        GotFileDownloadUrl value ->
            case model.editing of
                Just article ->
                    case Decode.decodeValue (Decode.field "url" Decode.string) value of
                        Ok url ->
                            ( model
                            , Ports.saveEditedArticle (Article.encodeOne (Article.setCover (Just url) article))
                            , session
                            )

                        Err _ ->
                            ( model, Cmd.none, session )

                Nothing ->
                    ( model, Cmd.none, session )

        Toggle ->
            case model.editing of
                Just article ->
                    ( model
                    , Ports.getEditedArticle (Article.encodeOne article)
                    , Session.removeArticle article session
                    )

                Nothing ->
                    ( { model
                        | editing =
                            session
                                |> Session.getArticle model.id
                                |> Maybe.withDefault Article.placeholder
                                |> Just
                      }
                    , Cmd.none
                    , session
                    )

        GotArticle value ->
            case Decode.decodeValue Article.decodeOne value of
                Ok article ->
                    ( { model | editing = Nothing }
                    , Cmd.batch
                        [ Nav.pushUrl key ("/articles/" ++ article.id)
                        , Ports.saveEditedArticle (Article.encodeOne article)
                        ]
                    , Session.setArticle article session
                    )

                Err _ ->
                    ( model, Cmd.none, session )


view : Session.Data -> Model -> Skeleton.Document Msg
view session model =
    { title = "SOKOL SOKOL | Articles"
    , body =
        case session.user of
            Session.LoggedIn state ->
                case model.editing of
                    Just article ->
                        [ viewArticleEditing article ]

                    Nothing ->
                        case Session.getArticle model.id session of
                            Just article ->
                                [ viewArticleEditable article ]

                            Nothing ->
                                [ viewArticleEditing Article.placeholder ]

            Session.Anonymous ->
                case Session.getArticle model.id session of
                    Just article ->
                        [ viewArticle article ]

                    Nothing ->
                        [ Html.text "Loading..." ]
    }


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ Util.maybe article.cover Image.single
        , Text.h1 [] article.title
        , Html.div [] (paragraphs article)
        ]


viewArticleEditable : Article.Article -> Html.Html Msg
viewArticleEditable article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ Util.maybe article.cover Image.single
        , Text.h1 [] article.title
        , Html.div [] (paragraphs article)
        , Button.button Toggle "Edit"
        ]


filesDecoder : Decode.Decoder (List File.File)
filesDecoder =
    Decode.at [ "target", "files" ] (Decode.list File.decoder)


viewArticleEditing : Article.Article -> Html.Html Msg
viewArticleEditing article =
    Html.div
        []
        [ Image.editable { select = Pick, remove = Remove } article.cover
        , Html.article
            [ Attr.css
                [ Css.width (Css.px 780)
                , Css.display Css.inlineBlock
                ]
            ]
            [ Text.h1
                [ Attr.contenteditable True
                , Attr.id "title"
                ]
                article.title
            , Text.body
                [ Attr.contenteditable True
                , Attr.id "body"
                ]
                (paragraphs article)
            ]
        , Html.div
            [ Attr.css
                [ Css.width (Css.pct 100)
                , Css.textAlign Css.right
                ]
            ]
            [ Button.button Toggle "Save" ]
        ]


paragraphs : Article.Article -> List (Html.Html msg)
paragraphs article =
    article.body
        |> String.split "\n"
        |> List.map (List.singleton << Html.text)
        |> List.map (Html.p [])


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.uploadedImage GotFileDownloadUrl
        , Ports.receiveEditedArticle GotArticle
        ]
