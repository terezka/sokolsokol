module Page.Article exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Data.Article as Article
import Element.Color as Color
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
    }


init : Session.Data -> String -> ( Model, Cmd Msg, Session.Data )
init session id =
    ( { id = id }
    , Cmd.none
    , session
    )


type Msg
    = Toggle
    | Pick
    | GotFiles File.File (List File.File)
    | GotFileUrl String String
    | GotFileDownloadUrl Encode.Value


update : Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update session msg model =
    case msg of
        Pick ->
            ( model, Select.files [ "image/*" ] GotFiles, session )

        GotFiles file files ->
            ( model
            , Task.perform (GotFileUrl (Debug.log "here" <| File.name file)) (File.toUrl file)
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
            case Session.getArticle model.id session of
                Just article ->
                    case Decode.decodeValue (Decode.field "url" Decode.string) value of
                        Ok url ->
                            ( model
                            , Ports.saveEditedArticle (Article.encodeOne (Article.setCover url article))
                            , session
                            )

                        Err _ ->
                            ( model, Cmd.none, session )

                Nothing ->
                    ( model, Cmd.none, session )

        Toggle ->
            case Session.getArticle model.id session of
                Just article ->
                    ( model
                    , case session.user of
                        Session.LoggedIn state ->
                            if state.editing then
                                Ports.saveEditedArticle (Article.encodeOne article)

                            else
                                Cmd.none

                        Session.Anonymous ->
                            Cmd.none
                    , Session.toggleEditing session
                    )

                Nothing ->
                    ( model, Cmd.none, session )


view : Session.Data -> Model -> Skeleton.Document Msg
view session model =
    { title = "SOKOL SOKOL | Articles"
    , body =
        case Session.getArticle model.id session of
            Just article ->
                case session.user of
                    Session.LoggedIn state ->
                        if state.editing then
                            [ viewArticleEditing article ]

                        else
                            [ viewArticleEditable article ]

                    Session.Anonymous ->
                        [ viewArticle article ]

            Nothing ->
                [ Html.text "loading" ]
    }


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ case article.cover of
            Just url ->
                Html.img
                    [ Attr.css
                        [ Css.property "width" "calc(100% - 8px)"
                        , Css.marginBottom (Css.px 8)
                        ]
                    , Attr.src url
                    ]
                    []

            Nothing ->
                Html.text ""
        , Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text article.title ]
        , Html.div []
            (paragraphs article)
        ]


viewArticleEditable : Article.Article -> Html.Html Msg
viewArticleEditable article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ case article.cover of
            Just url ->
                Html.img
                    [ Attr.css
                        [ Css.property "width" "calc(100% - 8px)"
                        , Css.marginBottom (Css.px 8)
                        ]
                    , Attr.src url
                    ]
                    []

            Nothing ->
                Html.text ""
        , Html.h1
            [ Attr.css [ Css.textDecoration Css.overline, Css.marginTop Css.zero ] ]
            [ Html.text article.title ]
        , Html.div []
            (paragraphs article)
        , Html.button
            [ Attr.css
                [ Css.backgroundColor Color.transparent
                , Css.border3 (Css.px 1) Css.solid Color.black
                ]
            , Events.onClick Toggle
            ]
            [ Html.text "Edit" ]
        ]


filesDecoder : Decode.Decoder (List File.File)
filesDecoder =
    Decode.at [ "target", "files" ] (Decode.list File.decoder)


viewArticleEditing : Article.Article -> Html.Html Msg
viewArticleEditing article =
    Html.div
        []
        [ case article.cover of
            Just url ->
                Html.img
                    [ Attr.css
                        [ Css.width (Css.px 100)
                        , Css.marginRight (Css.px 8)
                        ]
                    , Attr.src url
                    , Events.onClick Pick
                    ]
                    []

            Nothing ->
                Html.div
                    [ Attr.css
                        [ Css.width (Css.px 100)
                        , Css.height (Css.px 100)
                        , Css.marginRight (Css.px 8)
                        , Css.backgroundColor Color.blue
                        ]
                    , Events.onClick Pick
                    ]
                    []
        , Html.article
            [ Attr.css
                [ Css.width (Css.px 780)
                ]
            ]
            [ Html.div
                [ Attr.css
                    [ Css.textDecoration Css.overline
                    , Css.border (Css.px 0)
                    , Css.fontWeight (Css.int 500)
                    , Css.fontSize (Css.px 32)
                    , Css.outline Css.none
                    ]
                , Attr.contenteditable True
                , Attr.id "title"
                ]
                [ Html.text article.title ]
            , Html.div
                [ Attr.css
                    [ Css.border (Css.px 0)
                    , Css.fontWeight (Css.int 400)
                    , Css.fontSize (Css.px 16)
                    , Css.outline Css.none
                    , Css.marginTop (Css.px 12)
                    ]
                , Attr.contenteditable True
                , Attr.id "body"
                ]
                (paragraphs article)
            ]
        , Html.button
            [ Attr.css
                [ Css.backgroundColor Color.transparent
                , Css.border3 (Css.px 1) Css.solid Color.black
                ]
            , Events.onClick Toggle
            ]
            [ Html.text "Save" ]
        ]


paragraphs : Article.Article -> List (Html.Html msg)
paragraphs article =
    article.body
        |> String.split "\n"
        |> List.map (List.singleton << Html.text)
        |> List.map (Html.p [])


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.uploadedImage GotFileDownloadUrl
