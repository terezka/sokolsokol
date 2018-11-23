module Data.Status exposing (Status(..), map, withDefault)


type Status a
    = Loading
    | Success a


map : (a -> b) -> Status a -> Status b
map f status =
    case status of
        Loading ->
            Loading

        Success a ->
            Success (f a)


withDefault : a -> Status a -> a
withDefault default status =
    case status of
        Loading ->
            default

        Success a ->
            a
