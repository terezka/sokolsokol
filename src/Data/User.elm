module Data.User exposing (User, decodeOne)

import Json.Decode as Decode
import Json.Encode as Encode


type alias User =
    { email : String }


decodeOne : Decode.Decoder User
decodeOne =
    Decode.map User
        (Decode.field "email" Decode.string)
