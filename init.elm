module Model exposing (Model, Card, GameState, init)

import Assets

type alias Index = Int

type alias Model = 
    { cards: Array Card
    , gameState: GameState
    }

type alias Card =
    { imageSource: String
    , turned: Bool
    , found: Bool
    , pairId: Int
    }

type GameState
    = Initial
    | BeforeGuess
    | AfterGuessOne Index
    | Failed Index Index
    | Win


init : (Model, Cmd Msg)
init = (Model mockData Initial, getRandomFloats <| length mockData)


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