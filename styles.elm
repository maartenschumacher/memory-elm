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

imagesContainer =
    [ display flex'
    , flexDirection row
    , flexWrap wrap
    , width (px 900)
    ]


imageContainer =
    concat 
        [ centerLayout
        , [ height (px 200)
          , width (px 200)
          ]
        ]

image =
    [ height (px 200)
    , width (px 200)
    ]