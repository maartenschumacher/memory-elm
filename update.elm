module Update exposing (update, getRandomFloats)

import Process
import Time
import Task
import Random
import Array exposing (Array)

import Types exposing (..)
import Util exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    let 
        doNothing = (model, Cmd.none) 
    in
        case model.gameState of
            Initial ->
                case msg of
                    Shuffle randomFloats ->
                        ({ cards = shuffle randomFloats model.cards
                        , gameState = BeforeGuess
                        }, Cmd.none)

                    _ -> doNothing

            BeforeGuess ->
                case msg of
                    Turn index ->
                        ({ cards = turnCard index model.cards
                        , gameState = AfterGuessOne index
                        }, Cmd.none)

                    _ -> doNothing

            AfterGuessOne guess ->
                case msg of
                    Turn index ->
                        if isPair guess index model.cards then
                            ({ cards = turnCard index model.cards
                            , gameState = BeforeGuess
                            }, Cmd.none)
                        else 
                            ({ cards = turnCard index model.cards
                            , gameState = Failed guess index
                            }, unTurnCmd)

                    _ -> doNothing

            Failed indexA indexB ->
                case msg of
                    UnTurn ->
                        ({ cards = List.foldr unTurnCard model.cards [indexA, indexB]
                        , gameState = BeforeGuess
                        }, Cmd.none)

                    _ -> doNothing

            _ -> doNothing


getRandomFloats : Int -> Cmd Msg
getRandomFloats n = 
     Random.list n (Random.float 0 1) |> Random.generate Shuffle


unTurnCmd : Cmd Msg
unTurnCmd = Process.sleep Time.second |> Task.perform (id NoOp) (id UnTurn)


updateCard : Bool -> Int -> Array Card -> Array Card
updateCard turned index array =
    let
        card = unsafeUnwrap <| Array.get index array
        turn = \card -> { card | turned = turned }
    in
        Array.set index (turn card) array


turnCard = updateCard True
unTurnCard = updateCard False


isPair : Int -> Int -> Array Card -> Bool
isPair indexA indexB cards =
    let
        getCard index = unsafeUnwrap <| Array.get index cards
    in
        .pairId (getCard indexA) == .pairId (getCard indexB)