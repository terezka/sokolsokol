module Page.Article exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Data.Article as Article
import Element.Color as Color
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Skeleton as Skeleton
import Ports
import Session


type alias Model =
    { article : Maybe Article.Article
    }


init : Session.Data -> String -> ( Model, Cmd Msg, Session.Data )
init session id =
    ( { article = Nothing }
    , Ports.fetchArticles (Encode.object [ ( "id", Encode.string id ) ])
    , session
    )


type Msg
    = GotArticle Encode.Value
    | Toggle


update : Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update session msg model =
    case msg of
        GotArticle value ->
            case Decode.decodeValue Article.decodeOne value of
                Ok article ->
                    ( { model | article = Just article }, Cmd.none, session )

                Err _ ->
                    ( model, Cmd.none, session )

        Toggle ->
            case model.article of
                Just article ->
                    ( model
                    , case session.user of
                        Session.LoggedIn state ->
                            if state.editing then
                                Ports.fetchEditedArticle (Encode.object [ ( "id", Encode.string article.id ) ])

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
        case model.article of
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
        [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text article.title ]
        , Html.div []
            (paragraphs article)
        ]



viewArticleEditable : Article.Article -> Html.Html Msg
viewArticleEditable article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text article.title ]
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


viewArticleEditing : Article.Article -> Html.Html Msg
viewArticleEditing article =
    Html.div
        []
        [ Html.article
            [ Attr.css
                [ Css.maxWidth (Css.px 780)
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
    Sub.batch
        [ Ports.receiveArticle GotArticle
        ]
