module Page.Articles exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Data.Article as Article
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
    , body = List.map viewArticle (Session.getArticles session)
    }


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 300) ] ]
        [ Html.a [ Attr.href ("/articles/" ++ article.id) ]
            [ Html.h1
                [ Attr.css [ Css.textDecoration Css.overline ] ]
                [ Html.text article.title ]
            ]
        , Html.p [] [ Html.text article.body ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
