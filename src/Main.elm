module Main exposing (main)

import Browser
import Css
import Css.Global
import Html.Styled as Html


main : Program () () msg
main =
    Browser.document
        { init = \_ -> ( (), Cmd.none )
        , update = \_ _ -> ( (), Cmd.none )
        , view =
            \_ ->
                { title = "SOKOL SOKOL"
                , body =
                    List.map Html.toUnstyled
                        [ Css.Global.global
                            [ Css.Global.body
                                [ Css.displayFlex
                                , Css.padding Css.zero
                                , Css.margin Css.zero
                                , Css.width (Css.vw 100)
                                , Css.height (Css.vh 100)
                                , Css.alignItems Css.center
                                , Css.justifyContent Css.center
                                , Css.flexDirection Css.column
                                , Css.textAlign Css.center
                                ]
                            , Css.Global.main_
                                [ Css.property "font-family" "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'"
                                , Css.marginTop (Css.px 20)
                                ]
                            , Css.Global.h1
                                [ Css.fontWeight (Css.int 500)
                                , Css.fontSize (Css.px 32)
                                ]
                            , Css.Global.h2
                                [ Css.fontWeight (Css.int 300)
                                , Css.fontSize (Css.px 16)
                                ]
                            ]
                        , Html.main_
                            []
                            [ Html.h1 [] [ Html.text "SOKOL SOKOL" ]
                            , Html.h2 [] [ Html.text "Coming soon." ]
                            ]
                        ]
                }
        , subscriptions = \_ -> Sub.none
        }
