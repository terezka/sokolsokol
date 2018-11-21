module Element.Util exposing (maybe)


import Element.Color as Color
import Element.Button as Button
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events


maybe : Maybe a -> (a -> Html.Html msg) -> Html.Html msg
maybe maybeThing view =
    case maybeThing of
        Just thing -> view thing
        Nothing -> Html.text ""
