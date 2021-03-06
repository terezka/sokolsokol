module Session exposing
    ( Data
    , State
    , User(..)
    , empty
    , getArticle
    , getArticles
    , removeArticle
    , setArticle
    , setArticles
    , setUser
    , toggleEditing
    , withAdmin
    )

import Data.Article as Article
import Data.Status as Status
import Data.User as User
import Dict
import Html.Styled as Html


type alias Data =
    { articles : Status.Status (Dict.Dict Article.Id Article.Article)
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
    { articles = Status.Loading
    , user = Anonymous
    }


withAdmin : Data -> (State -> Html.Html msg) -> Html.Html msg
withAdmin data view =
    case data.user of
        LoggedIn state ->
            view state

        Anonymous ->
            Html.text ""


setArticles : List Article.Article -> Data -> Data
setArticles articles data =
    { data
        | articles =
            articles
                |> List.map (\a -> ( a.id, a ))
                |> Dict.fromList
                |> Status.Success
    }


setArticle : Article.Article -> Data -> Data
setArticle article data =
    { data | articles = Status.map (Dict.insert article.id article) data.articles }


removeArticle : Article.Id -> Data -> Data
removeArticle id data =
    { data | articles = Status.map (Dict.remove id) data.articles }


getArticles : Data -> List Article.Article
getArticles data =
    data.articles
        |> Status.map Dict.values
        |> Status.withDefault []


getArticle : Article.Id -> Data -> Status.Status (Maybe Article.Article)
getArticle id data =
    Status.map (Dict.get id) data.articles


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
