module Data.Article exposing (Article, Id, decodeMany, decodeOne, encodeOne, placeholder, setCover)

import Json.Decode as Decode
import Json.Encode as Encode


type alias Article =
    { id : Id
    , cover : Maybe String
    , title : String
    , body : String
    }


type alias Id =
    String


setCover : Maybe String -> Article -> Article
setCover url article =
    { article | cover = url }


placeholder : Article
placeholder =
    { id = "placeholder"
    , cover = Nothing
    , title = "Placeholder"
    , body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque."
    }


decodeOne : Decode.Decoder Article
decodeOne =
    Decode.map4 Article
        (Decode.field "id" Decode.string)
        (Decode.maybe (Decode.field "cover" Decode.string))
        (Decode.field "title" Decode.string)
        (Decode.field "body" Decode.string)


decodeMany : Decode.Decoder (List Article)
decodeMany =
    Decode.list decodeOne


encodeOne : Article -> Encode.Value
encodeOne article =
    Encode.object
        [ ( "id", Encode.string article.id )
        , ( "cover"
          , case article.cover of
                Just url ->
                    Encode.string url

                Nothing ->
                    Encode.null
          )
        , ( "title", Encode.string article.title )
        , ( "body", Encode.string article.body )
        ]
