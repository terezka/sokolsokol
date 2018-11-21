module Data.Article exposing (Article, decodeMany, decodeOne)

import Json.Decode as Decode


type alias Article =
    { title : String
    , body : String
    }


decodeOne : Decode.Decoder Article
decodeOne =
    Decode.map2 Article
        (Decode.field "title" Decode.string)
        (Decode.field "body" Decode.string)


decodeMany : Decode.Decoder (List Article)
decodeMany =
    Decode.list decodeOne
