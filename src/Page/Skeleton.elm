module Page.Skeleton exposing (Document, view)

import Browser
import Css
import Css.Global
import Element.Color
import Html.Styled as Html
import Html.Styled.Attributes as Attr


type alias Document msg =
    { title : String
    , body : List (Html.Html msg)
    }


view : (a -> msg) -> Document a -> Browser.Document msg
view toMsg document =
    { title = document.title
    , body =
        List.map Html.toUnstyled
            [ Css.Global.global styles
            , Html.menu
                [ Attr.css
                    [ Css.position Css.fixed
                    , Css.top Css.zero
                    ]
                ]
                [ Html.a [ Attr.href "/" ] [ logo ] ]
            , Html.main_ [] (List.map (Html.map toMsg) document.body)
            ]
    }


logo : Html.Html msg
logo =
    Html.h1
        [ Attr.css [ Css.marginBottom (Css.px 8) ]
        ]
        [ Html.text "SOKOL SOKOL" ]


nav : List (Html.Html msg) -> Html.Html msg
nav =
    Html.nav
        [ Attr.css [ Css.margin2 (Css.px 0) (Css.px 12) ] ]


navItem : String -> String -> Html.Html msg
navItem link linkText =
    Html.a
        [ Attr.css
            [ Css.marginLeft (Css.px 20)
            , Css.fontSize (Css.px 16)
            ]
        , Attr.href link
        ]
        [ Html.text linkText ]



-- GLOBAL STYLES


styles : List Css.Global.Snippet
styles =
    [ Css.Global.body
        [ Css.property "font-family" "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'"
        , Css.padding Css.zero
        , Css.margin Css.zero
        ]
    , Css.Global.menu
        [ Css.margin Css.zero
        ]
    , Css.Global.main_
        [ Css.displayFlex
        , Css.padding Css.zero
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        , Css.flexDirection Css.column
        , Css.marginRight Css.zero
        , Css.marginTop (Css.px 200)
        , Css.marginBottom (Css.px 200)
        , Css.marginLeft (Css.px 200)
        ]
    , Css.Global.h1
        [ Css.fontWeight (Css.int 500)
        , Css.fontSize (Css.px 32)
        ]
    , Css.Global.h2
        [ Css.fontWeight (Css.int 300)
        , Css.fontSize (Css.px 16)
        ]
    , Css.Global.a
        [ Css.fontWeight (Css.int 300)
        , Css.fontSize (Css.px 12)
        , Css.cursor Css.pointer
        , Css.textDecoration Css.none
        , Css.color Element.Color.black
        , Css.hover
            [ Css.color Element.Color.blue ]
        ]
    ]
