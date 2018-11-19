module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css
import Css.Global
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Page.Article as Article
import Page.Design as Design
import Page.Skeleton as Skeleton
import Session
import Url
import Url.Parser as Parser exposing ((</>), Parser, custom, fragment, map, oneOf, s, top)


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound Session.Data
    | Article Article.Model
    | Design Design.Model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound _ ->
            Skeleton.view never
                { title = "SOKOL SOKOL | Not found."
                , body = [ Html.text "Not found." ]
                }

        Article articleModel ->
            Skeleton.view ArticleMsg (Article.view articleModel)

        Design designModel ->
            Skeleton.view DesignMsg (Design.view designModel)



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    stepUrl url
        { key = key
        , page = NotFound Session.empty
        }



-- UPDATE


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ArticleMsg Article.Msg
    | DesignMsg Design.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        UrlChanged url ->
            stepUrl url model

        ArticleMsg msg ->
            case model.page of
                Article articleModel ->
                    stepArticle model (Article.update msg articleModel)

                _ ->
                    ( model, Cmd.none )

        DesignMsg msg ->
            case model.page of
                Design designModel ->
                    stepDesign model (Design.update msg designModel)

                _ ->
                    ( model, Cmd.none )


stepArticle : Model -> ( Article.Model, Cmd Article.Msg ) -> ( Model, Cmd Msg )
stepArticle model ( articleModel, cmds ) =
    ( { model | page = Article articleModel }
    , Cmd.map ArticleMsg cmds
    )


stepDesign : Model -> ( Design.Model, Cmd Design.Msg ) -> ( Model, Cmd Msg )
stepDesign model ( articleModel, cmds ) =
    ( { model | page = Design articleModel }
    , Cmd.map DesignMsg cmds
    )



-- EXIT


exit : Model -> Session.Data
exit model =
    case model.page of
        NotFound session ->
            session

        Article m ->
            m.session

        Design m ->
            m.session



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        session =
            exit model

        parser =
            oneOf
                [ route top
                    (stepArticle model (Article.init session))
                , route (s "articles")
                    (stepArticle model (Article.init session))
                , route (s "designs")
                    (stepDesign model (Design.init session))
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound session }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser
