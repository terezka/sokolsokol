port module Page.Admin exposing (Model, Msg, init, update, view, subscriptions)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Page.Skeleton as Skeleton
import Session
import Json.Encode as Encode
import Json.Decode as Decode


type alias Model =
    { session : Session.Data
    , email : String
    , password : String
    , error : Maybe String
    }


init : Session.Data -> ( Model, Cmd Msg )
init session =
    ( Model session "" "" Nothing, Cmd.none )


type Msg
    = UpdateEmail String
    | UpdatePassword String
    | Submit
    | GotError Encode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateEmail email ->
            ( {model | email = email}, Cmd.none )

        UpdatePassword password ->
            ( {model | password = password}, Cmd.none )

        Submit ->
            ( model
            , authenticate (encodeUser model.email model.password)
            )

        GotError errorValue ->
            case Decode.decodeValue decodeError errorValue of
                Ok ( code, message ) ->
                    ( { model | error = Just message }, Cmd.none )

                Err _ ->
                    ( { model | error = Just "Could not decode error" }, Cmd.none )





view : Model -> Skeleton.Document Msg
view model =
    { title = "SOKOL SOKOL | The wool pants"
    , body =
        [ Html.form
            [ Attr.css [ Css.maxWidth (Css.px 700) ] ]
            [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text "Sign in" ]
            , Html.input [ Attr.value model.email, Attr.type_ "email", Events.onInput UpdateEmail ] []
            , Html.input [ Attr.value model.password, Attr.type_ "password", Events.onInput UpdatePassword ] []
            , Html.div [ Events.onClick Submit ] [ Html.text "Submit" ]
            , case model.error of
                Just error -> Html.text error
                Nothing -> Html.text ""
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    authenticateError GotError


-- PORTS

port authenticate : Encode.Value -> Cmd msg

port authenticateError : (Encode.Value -> msg) -> Sub msg


encodeUser : String -> String -> Encode.Value
encodeUser email password =
    Encode.object
        [ ( "email", Encode.string email )
        , ( "password", Encode.string password )
        ]


decodeError : Decode.Decoder ( String, String )
decodeError =
    Decode.map2 Tuple.pair
        (Decode.field "code" Decode.string)
        (Decode.field "message" Decode.string)

