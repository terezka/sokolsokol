module Element.Text exposing (h1, h2, body)

import Element.Color as Color
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events

h1 : List (Html.Attribute msg) -> String -> Html.Html msg
h1 attrs content =
    Html.styled Html.h1
        [ Css.textDecoration Css.overline
         , Css.border (Css.px 0)
         , Css.fontWeight (Css.int 500)
         , Css.fontSize (Css.px 32)
         , Css.outline Css.none
         , Css.firstChild [ Css.marginTop Css.zero ]
         ]
        attrs
        [ Html.text content ]



h2 : List (Html.Attribute msg) ->  String -> Html.Html msg
h2 attrs content =
    Html.styled Html.h2
        [ Css.border (Css.px 0)
         , Css.fontWeight (Css.int 300)
         , Css.fontSize (Css.px 16)
         , Css.outline Css.none
         , Css.firstChild [ Css.marginTop Css.zero ]
         ]
        attrs
        [ Html.text content ]



body : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
body attrs content =
    Html.styled Html.h2
        [ Css.border (Css.px 0)
         , Css.fontWeight (Css.int 400)
         , Css.fontSize (Css.px 16)
         , Css.outline Css.none
         ]
        attrs
        content
