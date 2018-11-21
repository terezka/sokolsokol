port module Page.Admin exposing (Model, Msg, init, subscriptions, update, view)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import Json.Encode as Encode
import Page.Skeleton as Skeleton
import Session


type alias Model =
    { email : String
    , password : String
    , message : Maybe String
    }


init : Session.Data -> ( Model, Cmd Msg, Session.Data)
init session =
    ( Model "" "" Nothing, Cmd.none, session )


type Msg
    = UpdateEmail String
    | UpdatePassword String
    | Submit
    | GotError Encode.Value


update : Session.Data -> Msg -> Model -> ( Model, Cmd Msg, Session.Data )
update session msg model =
    case msg of
        UpdateEmail email ->
            ( { model | email = email }, Cmd.none, session )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none, session  )

        Submit ->
            ( model
            , authenticate (encodeUser model.email model.password)
            , session
            )

        GotError messageValue ->
            case Decode.decodeValue decodeResponse messageValue of
                Err _ ->
                    ( { model | message = Just "Could not decode error" }, Cmd.none, session  )

                Ok (Err ( code, message )) ->
                    ( { model | message = Just message }, Cmd.none, session  )

                Ok (Ok _) ->
                    ( { model | message = Just "Logged in!" }, Cmd.none, session  )


view : Session.Data -> Model -> Skeleton.Document Msg
view session model =
    { title = "SOKOL SOKOL | The wool pants"
    , body =
        [ Html.form
            [ Attr.css [ Css.maxWidth (Css.px 700) ] ]
            [ Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text "Sign in" ]
            , Html.input [ Attr.value model.email, Attr.type_ "email", Events.onInput UpdateEmail ] []
            , Html.input [ Attr.value model.password, Attr.type_ "password", Events.onInput UpdatePassword ] []
            , Html.div [ Events.onClick Submit ] [ Html.text "Submit" ]
            , case model.message of
                Just message ->
                    Html.text message

                Nothing ->
                    Html.text ""
            ]
        ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    authenticateResponse GotError



-- PORTS


port authenticate : Encode.Value -> Cmd msg


port authenticateResponse : (Encode.Value -> msg) -> Sub msg


encodeUser : String -> String -> Encode.Value
encodeUser email password =
    Encode.object
        [ ( "email", Encode.string email )
        , ( "password", Encode.string password )
        ]


decodeResponse : Decode.Decoder (Result ( String, String ) Bool)
decodeResponse =
    Decode.oneOf
        [ Decode.map Ok
            (Decode.field "success" Decode.bool)
        , Decode.map2 (\c m -> Err ( c, m ))
            (Decode.field "code" Decode.string)
            (Decode.field "message" Decode.string)
        ]
