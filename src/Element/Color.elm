module Element.Color exposing (black, blue, transparent)

import Css


blue : Css.Color
blue =
    Css.hex "97d4ff"


black : Css.Color
black =
    Css.hex "000000"


transparent : Css.Color
transparent =
    Css.rgba 0 0 0 0
