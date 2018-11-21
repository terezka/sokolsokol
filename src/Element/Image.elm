module Element.Image exposing (thumbnail, single, editable)


import Element.Color as Color
import Element.Button as Button
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events


thumbnail : String -> Html.Html msg
thumbnail url =
    Html.div
        [ Attr.css
            [ Css.width (Css.px 100)
            , Css.height (Css.px 100)
            , Css.backgroundImage (Css.url url)
            , Css.backgroundPosition Css.center
            ]
        ]
        []


single : String -> Html.Html msg
single url =
    Html.img
        [ Attr.css
            [ Css.property "width" "calc(100% - 8px)"
            , Css.marginBottom (Css.px 8)
            ]
        , Attr.src url
        ]
        []


editable : { select : msg, remove : msg } -> Maybe String -> Html.Html msg
editable msg maybeUrl =
    let
        layover =
            case maybeUrl of
                Just url ->
                    [ Button.button msg.remove "Remove"
                    , Button.button msg.select "Change"
                    ]

                Nothing ->
                    [ Button.button msg.select "Add cover"
                    ]
    in

    Html.div
        [ Attr.css
            [ Css.width (Css.px 200)
            , Css.height (Css.px 200)
            , Css.display Css.inlineBlock
            , Css.verticalAlign Css.top
            , Css.marginRight (Css.px 48)
            , case maybeUrl of
                Just url ->
                    Css.batch
                        [ Css.backgroundImage (Css.url url)
                        , Css.backgroundPosition Css.center
                        , Css.backgroundSize Css.cover
                        ]

                Nothing ->
                    Css.batch
                        [ Css.backgroundColor Color.gray
                        ]
            ]
        ]
        [ Html.div
            [ Attr.css
                [ Css.width (Css.px 200)
                , Css.height (Css.px 200)
                , Css.displayFlex
                , Css.alignItems Css.center
                , Css.justifyContent Css.center
                , Css.opacity (Css.int 0)
                , Css.hover
                    [ Css.opacity (Css.int 1)
                    ]
                ]
            ]
            layover
        ]


