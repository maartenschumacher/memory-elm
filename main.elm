import Html.App exposing (program)

import Model exposing (init)
import View exposing (view)
import Update exposing (update)


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
