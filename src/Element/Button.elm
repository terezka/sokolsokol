module Element.Button exposing (button)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Element.Color as Color
import Html.Styled.Events as Events


button : msg -> String -> Html.Html msg
button onClick content =
    Html.button
        [ Attr.css
            [ Css.backgroundColor Color.white
            , Css.border3 (Css.px 1) Css.solid Color.black
            , Css.padding2 (Css.px 4) (Css.px 8)
            , Css.outline Css.none
            , Css.margin2 (Css.px 0) (Css.px 8)
            , Css.firstChild
                [ Css.marginLeft Css.zero ]
            , Css.lastChild
                [ Css.marginRight Css.zero ]
            , Css.hover
                [ Css.backgroundColor Color.black
                , Css.color Color.white
                ]
            ]
        , Events.onClick onClick
        ]
        [ Html.text content ]
