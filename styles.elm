module Styles exposing (..)

import Style exposing (..)
import List exposing (concat)

columnLayout =
    [ display flex'
    , flexDirection column
    , alignItems center
    ]

centerLayout =
    [ display flex'
    , justifyContent center
    , alignItems center
    ]

container = columnLayout

imageContainer =
    [ display flex'
    , flexDirection row
    , flexWrap wrap
    , width (px 900)
    ]

image =
    [ height (px 200)
    , width (px 200)
    ]