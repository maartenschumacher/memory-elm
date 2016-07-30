module Types exposing (..)

import Array exposing (Array)

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


type Msg
    = Shuffle (List Float)
    | Turn Index
    | UnTurn
    | Reset
    | NoOp