port module Ports exposing (fetchArticles, fetchEditedArticle, receiveArticle, receiveArticles)

import Data.Article as Article
import Json.Decode as Decode
import Json.Encode as Encode


port fetchArticles : Encode.Value -> Cmd msg


port receiveArticles : (Encode.Value -> msg) -> Sub msg


port receiveArticle : (Encode.Value -> msg) -> Sub msg


port fetchEditedArticle : Encode.Value -> Cmd msg
