module Element.Color exposing (black, white, gray, blue, transparent)

import Css


blue : Css.Color
blue =
    Css.hex "97d4ff"


black : Css.Color
black =
    Css.hex "000000"


gray : Css.Color
gray =
    Css.hex "f5f5f5"


white : Css.Color
white =
    Css.hex "ffffff"


transparent : Css.Color
transparent =
    Css.rgba 0 0 0 0


