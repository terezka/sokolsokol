module Page.Skeleton exposing (Document, view)

import Browser
import Css
import Css.Global
import Element.Color as Color
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Session


type alias Document msg =
    { title : String
    , body : List (Html.Html msg)
    }


view : (a -> msg) -> Session.Data -> Document a -> Browser.Document msg
view toMsg session document =
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
        [ Attr.css
            [ Css.marginBottom (Css.px 8)
            , Css.padding (Css.px 8)
            , Css.backgroundColor Color.white
            ]
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
        , Css.property "width" "calc(100vw - 120px)"
        , Css.margin Css.zero
        , Css.marginTop (Css.px 100)
        , Css.marginBottom (Css.px 100)
        , Css.marginLeft (Css.px 120)
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
        , Css.color Color.black
        , Css.hover
            [ Css.color Color.blue ]
        ]
    ]
