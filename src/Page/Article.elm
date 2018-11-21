module Page.Article exposing (Model, Msg, init, subscriptions, update, view)

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
    { session : Session.Data
    , article : Maybe Article.Article
    }


init : Session.Data -> String -> ( Model, Cmd Msg )
init session id =
    ( { session = session, article = Nothing }
    , Ports.fetchArticles (Encode.object [ ( "id", Encode.string id ) ])
    )


type Msg
    = GotArticle Encode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotArticle value ->
            case Decode.decodeValue Article.decodeOne value of
                Ok article ->
                    ( { model | article = Just article }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


view : Model -> Skeleton.Document Msg
view model =
    { title = "SOKOL SOKOL | Articles"
    , body =
        case model.article of
            Just article ->
                [ viewArticle article ]

            Nothing ->
                [ Html.text "loading" ]
    }


viewArticle : Article.Article -> Html.Html Msg
viewArticle article =
    Html.article
        [ Attr.css [ Css.maxWidth (Css.px 1080), Css.property "column-count" "3" ] ]
        [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text article.title ]
        , Html.p [] [ Html.text article.body ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.receiveArticle GotArticle
