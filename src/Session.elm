module Session exposing
    ( Data
    , User(..)
    , State
    , setUser
    , empty
    )

import Data.User as User

type alias Data =
    { user : User }


type User
    = LoggedIn State
    | Anonymous


type alias State =
    { user : User.User
    , editing : Bool
    }


empty : Data
empty =
    { user = Anonymous }


setUser : Maybe User.User -> Data -> Data
setUser maybeUser data =
    case maybeUser of
        Just user ->
            { data | user = LoggedIn {user = user, editing = False} }

        Nothing ->
            { data | user = Anonymous }
