module Element.Image exposing (decodeUrl, editable, encodeUrl, single, thumbnail)

import Css
import Css.Animations
import Css.Transitions
import Element.Button as Button
import Element.Color as Color
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Json.Decode as Decode
import Json.Encode as Encode


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


single : (String -> msg) -> Bool -> String -> Html.Html msg
single onLoad isLoaded url =
    Html.img
        [ Attr.css
            [ Css.property "width" "calc(100% - 8px)"
            , Css.marginBottom (Css.px 8)
            , if isLoaded then
                Css.opacity (Css.int 1)

              else
                Css.opacity (Css.int 0)
            , Css.Transitions.transition [ Css.Transitions.opacity3 200 0 Css.Transitions.easeIn ]
            ]
        , Attr.src url
        , Events.on "load" (Decode.succeed (onLoad url))
        ]
        []


editable : { select : msg, remove : msg } -> Maybe String -> Html.Html msg
editable msg maybeUrl =
    let
        layover =
            case maybeUrl of
                Just url ->
                    [ Button.warning msg.remove "Remove"
                    , Button.basic msg.select "Change"
                    ]

                Nothing ->
                    [ Button.basic msg.select "Add cover"
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


fadeInAnimation : Css.Style
fadeInAnimation =
    Css.batch
        [ Css.animationName fadeInKeyframes
        , Css.animationDuration (Css.sec 0.4)
        , Css.animationDelay (Css.sec 0.2)
        ]


fadeInKeyframes : Css.Animations.Keyframes {}
fadeInKeyframes =
    Css.Animations.keyframes
        [ ( 0, [ Css.Animations.opacity Css.zero ] )
        , ( 100, [ Css.Animations.opacity (Css.num 1) ] )
        ]



-- FILE UPLOAD


decodeUrl : Decode.Decoder String
decodeUrl =
    Decode.field "url" Decode.string


encodeUrl : String -> String -> Encode.Value
encodeUrl name url =
    Encode.object
        [ ( "name", Encode.string name )
        , ( "url", Encode.string url )
        ]
