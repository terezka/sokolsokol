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
    { session : Session.Data
    , editing : Bool
    , article : Maybe Article.Article
    }


init : Session.Data -> String -> ( Model, Cmd Msg )
init session id =
    ( { session = session, editing = False, article = Nothing }
    , Ports.fetchArticles (Encode.object [ ( "id", Encode.string id ) ])
    )


type Msg
    = GotArticle Encode.Value
    | Toggle


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotArticle value ->
            case Decode.decodeValue Article.decodeOne value of
                Ok article ->
                    ( { model | article = Just article }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        Toggle ->
            case model.article of
                Just article ->
                    ( { model | editing = not model.editing }
                    , if not model.editing then Cmd.none else Ports.fetchEditedArticle (Encode.object [ ( "id", Encode.string article.id ) ])
                    )

                Nothing ->
                    ( model, Cmd.none )




view : Model -> Skeleton.Document Msg
view model =
    { title = "SOKOL SOKOL | Articles"
    , body =
        case model.article of
            Just article ->
                if model.editing then
                    [ viewArticleEditable article ]
                else
                    [ viewArticle article ]

            Nothing ->
                [ Html.text "loading" ]
    }


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    let
        paragraphs =
            article.body
                |> String.split "\n"
                |> List.map (List.singleton << Html.text)
                |> List.map (Html.p [])
    in

    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text article.title ]
        , Html.div [] paragraphs
        , Html.button
            [ Attr.css
                [ Css.backgroundColor Color.transparent
                , Css.border3 (Css.px 1) Css.solid Color.black
                ]
            , Events.onClick Toggle ]
            [ Html.text "Edit" ]
        ]


viewArticleEditable : Article.Article -> Html.Html Msg
viewArticleEditable article =
    let
        paragraphs =
            article.body
                |> String.split "\n"
                |> List.map (List.singleton << Html.text)
                |> List.map (Html.p [])
    in
    Html.div
        [ Attr.css
            [ Css.border3 (Css.px 1) Css.dotted Color.black
            , Css.padding (Css.px 24)
            ]
        ]
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
                paragraphs
            ]
        , Html.button
            [ Attr.css
                [ Css.backgroundColor Color.transparent
                , Css.border3 (Css.px 1) Css.solid Color.black
                ]
            , Events.onClick Toggle ]
            [ Html.text "Save" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.receiveArticle GotArticle
        ]
