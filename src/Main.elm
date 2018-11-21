module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Css
import Css.Global
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Admin as Admin
import Page.Article as Article
import Page.Articles as Articles
import Page.Skeleton as Skeleton
import Session
import Data.User as User
import Data.Article as Article
import Url
import Url.Parser as Parser exposing ((</>), Parser, custom, fragment, map, oneOf, s, string, top)
import Ports

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
    , session : Session.Data
    , page : Page
    }


type Page
    = NotFound
    | Articles Articles.Model
    | Article Article.Model
    | Admin Admin.Model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
    [ Ports.authenticationState OnAuthChange
    , Ports.receiveArticles GotArticles
    , case model.page of
            Admin adminModel ->
                Admin.subscriptions adminModel
                    |> Sub.map AdminMsg

            Articles articlesModel ->
                Articles.subscriptions articlesModel
                    |> Sub.map ArticlesMsg

            Article articleModel ->
                Article.subscriptions articleModel
                    |> Sub.map ArticleMsg

            _ ->
                Sub.none]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        NotFound ->
            Skeleton.view never model.session
                { title = "SOKOL SOKOL | Not found."
                , body = [ Html.text "Not found." ]
                }

        Articles articlesModel ->
            Skeleton.view ArticlesMsg model.session (Articles.view model.session articlesModel)

        Article articleModel ->
            Skeleton.view ArticleMsg model.session (Article.view model.session articleModel)

        Admin adminModel ->
            Skeleton.view AdminMsg model.session (Admin.view model.session adminModel)



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( model, cmd ) =
            stepUrl url
                { key = key
                , page = NotFound
                , session = Session.empty
                }
    in
    ( model, Cmd.batch [ Ports.fetchArticles Encode.null, cmd ])



-- UPDATE


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | OnAuthChange Encode.Value
    | GotArticles Encode.Value
    | ArticlesMsg Articles.Msg
    | ArticleMsg Article.Msg
    | AdminMsg Admin.Msg


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

        OnAuthChange value ->
            case Decode.decodeValue User.decodeOne value of
                Ok user ->
                    ( { model | session = Session.setUser (Just user) model.session }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | session = Session.setUser Nothing model.session }
                    , Cmd.none
                    )

        GotArticles value ->
            case Decode.decodeValue Article.decodeMany value of
                Ok articles ->
                    ( { model | session = Session.setArticles articles model.session }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        ArticlesMsg msg ->
            case model.page of
                Articles article2Model ->
                    stepArticles model (Articles.update model.session msg article2Model)

                _ ->
                    ( model, Cmd.none )

        ArticleMsg msg ->
            case model.page of
                Article articleModel ->
                    stepArticle model (Article.update model.session msg articleModel)

                _ ->
                    ( model, Cmd.none )

        AdminMsg msg ->
            case model.page of
                Admin designModel ->
                    stepAdmin model (Admin.update model.session msg designModel)

                _ ->
                    ( model, Cmd.none )


stepArticles : Model -> ( Articles.Model, Cmd Articles.Msg, Session.Data ) -> ( Model, Cmd Msg )
stepArticles model ( articlesModel, cmds, session ) =
    ( { model | page = Articles articlesModel, session = session }
    , Cmd.map ArticlesMsg cmds
    )


stepArticle : Model -> ( Article.Model, Cmd Article.Msg, Session.Data ) -> ( Model, Cmd Msg )
stepArticle model ( articleModel, cmds, session ) =
    ( { model | page = Article articleModel, session = session }
    , Cmd.map ArticleMsg cmds
    )



stepAdmin : Model -> ( Admin.Model, Cmd Admin.Msg, Session.Data ) -> ( Model, Cmd Msg )
stepAdmin model ( articleModel, cmds, session ) =
    ( { model | page = Admin articleModel, session = session }
    , Cmd.map AdminMsg cmds
    )



-- ROUTER


stepUrl : Url.Url -> Model -> ( Model, Cmd Msg )
stepUrl url model =
    let
        parser =
            oneOf
                [ route top
                    (stepArticles model (Articles.init model.session))
                , route (s "articles")
                    (stepArticles model (Articles.init model.session))
                , route (s "articles" </> string)
                    (\id -> stepArticle model (Article.init model.session id))
                , route (s "admin")
                    (stepAdmin model (Admin.init model.session))
                ]
    in
    case Parser.parse parser url of
        Just answer ->
            answer

        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )


route : Parser a b -> a -> Parser (b -> c) c
route parser handler =
    Parser.map handler parser
