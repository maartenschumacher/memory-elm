module Model exposing (init)

import Array exposing (..)

import Types exposing (..)
import Update
import Assets



init : (Model, Cmd Msg)
init = (Model mockData Initial, Update.getRandomFloats <| length mockData)


mockData : Array Card
mockData =
    pairs <| List.indexedMap card Assets.images


pairs : List Card -> Array Card
pairs =
    let
        double = List.concatMap (\x -> [x, x])
    in
        List.foldr push empty << double


card : Int -> String -> Card
card pairId imageSource =
    { imageSource = imageSource
    , turned = False
    , found = False
    , pairId = pairId
    }