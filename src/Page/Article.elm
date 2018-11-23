module Page.Article exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation as Nav
import Css
import Data.Article as Article
import Data.Status as Status
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
import Markdown


type alias Model =
    { id : Article.Id
    , editing : Maybe Article.Article
    , errors : List String
    , imageLoaded : Bool
    }


init : Session.Data -> String -> ( Model, Cmd Msg, Session.Data )
init session id =
    ( case id of
        "new" ->
            { id = id
            , editing = Just Article.placeholder
            , imageLoaded = False
            , errors = []
            }

        _ ->
            { id = id
            , editing = Nothing
            , imageLoaded = False
            , errors = []
            }
    , Cmd.none
    , session
    )


type Msg
    = ImageLoaded String
    | ImageSelect
    | ImageRemove
    | ArticleRemove
    | ArticleCancel
    | ArticleToggle
    | GotFiles File.File (List File.File)
    | GotFileUrl String String
    | GotFileDownloadUrl Encode.Value
    | GotArticle Encode.Value
    | UpdateTitle String
    | UpdateBody String


update : Nav.Key -> Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update key session msg model =
    case msg of
        ImageLoaded _ ->
            ( { model | imageLoaded = True }
            , Cmd.none
            , session
            )

        ImageSelect ->
            ( model
            , Select.files [ "image/*" ] GotFiles
            , session
            )

        ImageRemove ->
            case model.editing of
                Just article ->
                    ( { model | editing = Just (Article.setCover Nothing article) }
                    , Cmd.none
                    , session
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    , session
                    )

        ArticleRemove ->
            ( model
            , Cmd.batch
                [ Ports.deleteEditedArticle (Article.encodeId model.id)
                , Nav.pushUrl key "/articles"
                ]
            , Session.removeArticle model.id session
            )

        ArticleCancel ->
            ( { model | editing = Nothing }
            , Cmd.none
            , session
            )

        ArticleToggle ->
            case model.editing of
                Just article ->
                    if String.isEmpty article.title then
                        ( { model | errors = [ "Title must not be empty." ] }
                        , Cmd.none
                        , session
                        )

                    else
                        ( model
                        , Ports.getEditedArticle (Article.encodeOne article)
                        , Session.removeArticle article.id session
                        )

                Nothing ->
                    case Session.getArticle model.id session of
                        Status.Success (Just article) ->
                            ( { model | editing = Just article }
                            , Cmd.none
                            , session
                            )

                        Status.Success Nothing ->
                            ( model
                            , Cmd.none
                            , session
                            )

                        Status.Loading ->
                            ( model
                            , Cmd.none
                            , session
                            )

        GotFiles file files ->
            ( model
            , Task.perform (GotFileUrl (File.name file)) (File.toUrl file)
            , session
            )

        GotFileUrl name url ->
            ( model
            , Ports.uploadImage (Image.encodeUrl name url)
            , session
            )

        GotFileDownloadUrl value ->
            case model.editing of
                Just article ->
                    case Decode.decodeValue Image.decodeUrl value of
                        Ok url ->
                            ( { model | editing = Just (Article.setCover (Just url) article) }
                            , Ports.saveEditedArticle (Article.encodeOne (Article.setCover (Just url) article))
                            , session
                            )

                        Err _ ->
                            ( model
                            , Cmd.none
                            , session
                            )

                Nothing ->
                    ( model
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
                    ( model
                    , Cmd.none
                    , session
                    )

        UpdateTitle title ->
            case model.editing of
                Just article ->
                    ( { model | editing = Just (Article.setTitle title article), errors = [] }
                    , Cmd.none
                    , session
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    , session
                    )

        UpdateBody body ->
            case model.editing of
                Just article ->
                    ( { model | editing = Just (Article.setBody body article) }
                    , Cmd.none
                    , session
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    , session
                    )


view : Session.Data -> Model -> Skeleton.Document Msg
view session model =
    case session.user of
        Session.LoggedIn state ->
            case model.editing of
                Just article ->
                    { title = "SOKOL SOKOL | " ++ article.title
                    , body = [ viewArticleEditing model article ]
                    }

                Nothing ->
                    case Session.getArticle model.id session of
                        Status.Success (Just article) ->
                            { title = "SOKOL SOKOL | " ++ article.title
                            , body =
                                [ viewArticle model
                                    article
                                    [ Button.warning ArticleRemove "Delete"
                                    , Button.basic ArticleToggle "Edit"
                                    ]
                                ]
                            }

                        Status.Success Nothing ->
                            { title = "SOKOL SOKOL | New article"
                            , body = [ viewArticleEditing model Article.placeholder ]
                            }

                        Status.Loading ->
                            { title = "SOKOL SOKOL | Loading"
                            , body = [ Html.text "Loading..." ]
                            }

        Session.Anonymous ->
            case Session.getArticle model.id session of
                Status.Success (Just article) ->
                    { title = "SOKOL SOKOL | " ++ article.title
                    , body = [ viewArticle model article [] ]
                    }

                Status.Success Nothing ->
                    { title = "SOKOL SOKOL | Not found."
                    , body = [ Html.text "Article not found." ]
                    }

                Status.Loading ->
                    { title = "SOKOL SOKOL | Loading"
                    , body = [ Html.text "Loading..." ]
                    }


viewArticle : Model -> Article.Article -> List (Html.Html Msg) -> Html.Html Msg
viewArticle model article buttons =
    threeColumn
        [ Util.maybe article.cover (Image.single ImageLoaded model.imageLoaded)
        , Text.h1 [] article.title
        , Html.div [] [ Html.fromUnstyled <| Markdown.toHtml [] article.body ]
        , menu buttons
        ]


filesDecoder : Decode.Decoder (List File.File)
filesDecoder =
    Decode.at [ "target", "files" ] (Decode.list File.decoder)


viewArticleEditing : Model -> Article.Article -> Html.Html Msg
viewArticleEditing model article =
    editable
        { aside = Image.editable { select = ImageSelect, remove = ImageRemove } article.cover
        , content =
            [ Html.node "autoresize-textarea"
                [ Attr.css
                    [ Css.textDecoration Css.overline
                    , Css.fontWeight (Css.int 500)
                    , Css.fontSize (Css.px 32)
                    ]
                , Events.onInput UpdateTitle
                , Attr.value article.title
                , Attr.attribute "data-placeholder" "Title"
                , Attr.attribute "data-value" article.title
                ]
                []
            , Html.node "autoresize-textarea"
                [ Attr.css
                    [ Css.fontWeight (Css.int 400)
                    , Css.fontSize (Css.px 16)
                    ]
                , Events.onInput UpdateBody
                , Attr.value article.body
                , Attr.attribute "data-placeholder" "Body"
                , Attr.attribute "data-value" article.body
                ]
                []
            ]
        , actions =
            [ Button.warning ArticleCancel "Cancel"
            , Button.basic ArticleToggle "Save"
            , Html.div [] <| List.map (\error -> Html.p [ Attr.css [ Css.color Color.red ] ] [ Html.text error ]) (model.errors)
            ]
        }


getTextContent : Decode.Decoder String
getTextContent =
    Decode.at [ "target", "outerText" ] Decode.string



-- ELEMENTS


threeColumn : List (Html.Html msg) -> Html.Html msg
threeColumn =
    Html.article
        [ Attr.css
            [ Css.maxWidth (Css.px 1080)
            , Css.property "column-count" "3"
            ]
        ]


editable : { aside : Html.Html msg, content : List (Html.Html msg), actions : List (Html.Html msg) } -> Html.Html msg
editable { aside, content, actions } =
    Html.article
        []
        [ aside
        , singleColumn content
        , menu actions
        ]


singleColumn : List (Html.Html msg) -> Html.Html msg
singleColumn =
    Html.div
        [ Attr.css
            [ Css.width (Css.px 780)
            , Css.display Css.inlineBlock
            ]
        ]


menu : List (Html.Html msg) -> Html.Html msg
menu =
    Html.div
        [ Attr.css
            [ Css.width (Css.pct 100)
            , Css.textAlign Css.right
            ]
        ]


paragraphs : Article.Article -> List (Html.Html msg)
paragraphs article =
    article.body
        |> String.split "\n"
        |> List.filter (not << String.isEmpty)
        |> List.map (List.singleton << Html.text)
        |> List.map (Html.p [])



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.uploadedImage GotFileDownloadUrl
        , Ports.receiveEditedArticle GotArticle
        ]
