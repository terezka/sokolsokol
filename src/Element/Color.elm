module Element.Color exposing (black, blue, gray, red, transparent, white)

import Css


blue : Css.Color
blue =
    Css.hex "97d4ff"


black : Css.Color
black =
    Css.hex "000000"


red : Css.Color
red =
    Css.hex "b12f2f"


gray : Css.Color
gray =
    Css.hex "f5f5f5"


white : Css.Color
white =
    Css.hex "ffffff"


transparent : Css.Color
transparent =
    Css.rgba 0 0 0 0
