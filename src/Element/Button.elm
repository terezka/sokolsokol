module Element.Button exposing (button)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events


button : msg -> String -> Html.Html msg
button onClick content =
    Html.button
        [ Attr.css
            [ Css.backgroundColor Color.transparent
            , Css.border3 (Css.px 1) Css.solid Color.black
            , Css.padding2 (Css.px 4) (Css.px 8)
            ]
        , Events.onClick onClick
        ]
        [ Html.text content ]
