module Page.Articles exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Data.Article as Article
import Html.Styled as Html
import Element.Text as Text
import Element.Color as Color
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
            [ Attr.css [ Css.maxWidth (Css.px 1100), Css.width (Css.pct 100) ] ]
            [ Html.h2
                [ Attr.css [ Css.maxWidth (Css.px 700) ] ]
                [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.div
                [ Attr.css []
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
            [ Css.width (Css.pct 30)
            , Css.height (Css.px 200)
            , Css.display Css.inlineBlock
            , Css.verticalAlign Css.top
            , Css.marginTop (Css.px 24)
            , Css.marginRight (Css.px 24)
            , Css.border3 (Css.px 1) Css.dotted Color.black
            , Css.display Css.inlineFlex
            , Css.justifyContent Css.center
            , Css.alignItems Css.center
            ]
        ]
        [ Text.body [] [ Html.text "Add new?" ]
        ]


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.article
        [ Attr.css
            [ Css.width (Css.pct 32)
            , Css.display Css.inlineBlock
            , Css.verticalAlign Css.top
            , Css.marginRight (Css.px 8)
            , Css.lastChild [ Css.marginRight (Css.pct 0) ]
            ]
        ]
        [ Html.a [ Attr.href ("/articles/" ++ article.id) ]
            [ Html.h1
                [ Attr.css [ Css.textDecoration Css.overline ] ]
                [ Html.text article.title ]
            ]
        , Html.p [] [ Html.text <| String.left 300 article.body ++ "..." ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
