module Session exposing
    ( Data
    , State
    , User(..)
    , empty
    , withAdmin
    , getArticle
    , getArticles
    , setArticle
    , setArticles
    , setUser
    , toggleEditing
    )

import Data.Article as Article
import Html.Styled as Html
import Data.User as User
import Dict


type alias Data =
    { articles : Dict.Dict Article.Id Article.Article
    , user : User
    }


type User
    = LoggedIn State
    | Anonymous


type alias State =
    { user : User.User
    , editing : Bool
    }


empty : Data
empty =
    { articles = Dict.empty
    , user = Anonymous
    }


withAdmin : Data -> (State -> Html.Html msg) -> Html.Html msg
withAdmin data view =
    case data.user of
        LoggedIn state -> view state
        Anonymous -> Html.text ""


setArticles : List Article.Article -> Data -> Data
setArticles articles data =
    { data
        | articles =
            articles
                |> List.map (\a -> ( a.id, a ))
                |> Dict.fromList
    }


setArticle : Article.Article -> Data -> Data
setArticle article data =
    { data | articles = Dict.insert article.id article data.articles }


getArticles : Data -> List Article.Article
getArticles data =
    Dict.values data.articles


getArticle : Article.Id -> Data -> Maybe Article.Article
getArticle id data =
    Dict.get id data.articles


setUser : Maybe User.User -> Data -> Data
setUser maybeUser data =
    case maybeUser of
        Just user ->
            { data | user = LoggedIn { user = user, editing = False } }

        Nothing ->
            { data | user = Anonymous }


toggleEditing : Data -> Data
toggleEditing data =
    case data.user of
        LoggedIn state ->
            { data | user = LoggedIn { state | editing = not state.editing } }

        Anonymous ->
            data
