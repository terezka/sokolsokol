module Data.Article exposing (Article, decodeMany, decodeOne)

import Json.Decode as Decode


type alias Article =
    { id : String
    , title : String
    , body : String
    }


decodeOne : Decode.Decoder Article
decodeOne =
    Decode.map3 Article
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "body" Decode.string)


decodeMany : Decode.Decoder (List Article)
decodeMany =
    Decode.list decodeOne
