module Page.Articles exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Css.Global
import Data.Article as Article
import Element.Color as Color
import Element.Text as Text
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Skeleton as Skeleton
import Ports
import Session


type alias Model =
    {}


init : Session.Data -> ( Model, Cmd Msg, Session.Data )
init session =
    ( {}
    , Cmd.none
    , session
    )


type Msg
    = Msg


update : Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update session msg model =
    ( model, Cmd.none, session )


view : Session.Data -> Model -> Skeleton.Document Msg
view session model =
    { title = "SOKOL SOKOL | Articles"
    , body =
        [ Html.div
            [ Attr.css
                [ Css.marginTop (Css.px 120)
                , Css.maxWidth (Css.px 1100)
                , Css.width (Css.pct 100)
                ]
            ]
            [ Html.h2
                [ Attr.css [ Css.maxWidth (Css.px 700) ] ]
                [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.div
                [ Attr.css
                    [ Css.property "display" "grid"
                    , Css.property "grid-template-columns" "33% 33% 33%"
                    ]
                ]
                (case session.user of
                    Session.LoggedIn _ ->
                        viewPlaceholder :: List.map viewArticle (Session.getArticles session)

                    Session.Anonymous ->
                        List.map viewArticle (Session.getArticles session)
                )
            ]
        ]
    }


viewPlaceholder : Html.Html Msg
viewPlaceholder =
    Html.a
        [ Attr.href "/articles/new"
        , Attr.css
            [ Css.padding2 (Css.px 0) (Css.px 16)
            , Css.paddingBottom (Css.px 16)
            , Css.hover
                [ Css.Global.children
                    [Css.Global.everything
                        [ Css.border3 (Css.px 3) Css.dotted Color.white ]]
                ]
            ]
        ]
        [ Html.div
            [ Attr.css
                [ Css.height (Css.px 200)
                , Css.marginTop (Css.px 24)
                , Css.border3 (Css.px 3) Css.dotted Color.black
                ]
            ]
            []
        ]


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.a
        [ Attr.href ("/articles/" ++ article.id)
        , Attr.css
            [ Css.padding2 (Css.px 0) (Css.px 16)
            , Css.paddingBottom (Css.px 16)
            ]
        ]
        [ Html.article
            []
            [ Html.h1
                [ Attr.css [ Css.textDecoration Css.overline ] ]
                [ Html.text article.title ]
            , Html.p [] [ Html.text <| String.left 300 article.body ++ "..." ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
