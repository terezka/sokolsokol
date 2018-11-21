port module Ports exposing
    ( authenticationState
    , fetchArticles
    , getEditedArticle
    , receiveArticle
    , receiveArticles
    , receiveEditedArticle
    , saveEditedArticle
    , uploadImage
    , uploadedImage
    )

import Data.Article as Article
import Json.Decode as Decode
import Json.Encode as Encode


port fetchArticles : Encode.Value -> Cmd msg


port receiveArticles : (Encode.Value -> msg) -> Sub msg


port receiveArticle : (Encode.Value -> msg) -> Sub msg


port saveEditedArticle : Encode.Value -> Cmd msg


port authenticationState : (Encode.Value -> msg) -> Sub msg


port uploadImage : Encode.Value -> Cmd msg


port uploadedImage : (Encode.Value -> msg) -> Sub msg


port getEditedArticle : Encode.Value -> Cmd msg


port receiveEditedArticle : (Encode.Value -> msg) -> Sub msg
