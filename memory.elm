import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.App as Html
import Dict exposing (Dict)
import Process
import Time
import Task
import Array exposing (..)
import Random
import Assets
import Styles

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- model

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

increment : Int -> Int
increment int = int + 1

updateCard : Bool -> Int -> Array Card -> Array Card
updateCard turned index array =
    let
        card = unsafeUnwrap <| get index array
        turn = \card -> { card | turned = turned }
    in
        set index (turn card) array

turnCard = updateCard True
unTurnCard = updateCard False

isPair : Int -> Int -> Array Card -> Bool
isPair indexA indexB cards =
    let
        getCard index = unsafeUnwrap <| get index cards
    in
        .pairId (getCard indexA) == .pairId (getCard indexB)

-- UPDATE

type Msg
    = Shuffle (List Float)
    | Turn Index
    | UnTurn
    | Reset
    | NoOp

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


unTurnCmd : Cmd Msg
unTurnCmd = Process.sleep Time.second |> Task.perform (id NoOp) (id UnTurn)

-- VIEW

view : Model -> Html Msg
view model =
    div [ style Styles.container ] 
        [ h1 [] [ text "memory" ]
        , div [ style Styles.imageContainer ] <| toList <| indexedMap cardView model.cards
        ]

cardView : Int -> Card -> Html Msg
cardView index card = 
    let
        buttonContent = 
            if card.turned then 
                [ img [ src card.imageSource, style Styles.image ] [] ] 
            else [ div [ style Styles.image ] [] ]

        action = if card.found || card.turned then NoOp else Turn index
    in
        button [ onClick action ] buttonContent


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HELPERS

card : Int -> String -> Card
card pairId imageSource =
    { imageSource = imageSource
    , turned = False
    , found = False
    , pairId = pairId
    }

mockData : Array Card
mockData =
    pairs <| List.indexedMap card Assets.images


pairs : List Card -> Array Card
pairs =
    let
        double = List.concatMap (\x -> [x, x])
    in
        List.foldr push empty << double

id : a -> () -> a
id a = \_ -> a


extract : Int -> Array a -> (a, Array a)
extract index array =
    if index >= 0 && index < (length array) then
        let
            prefix = slice 0 index array
            element = unsafeUnwrap <| get index array
            suffix = slice (index + 1) (length array) array
        in
            (element, append prefix suffix)
    else 
        Debug.crash "Index out of range"


getRandomFloats : Int -> Cmd Msg
getRandomFloats n = 
     Random.list n (Random.float 0 1) |> Random.generate Shuffle


shuffle : List Float -> Array a -> Array a
shuffle randomFloats array =
    if List.isEmpty randomFloats || isEmpty array then
        empty
    else
        let
            (result, newRandomFloats, newArray) =
                let 
                    index = (unsafeHead randomFloats) * (toFloat <| length array) |> floor
                    (result, newArray) = extract index array
                in
                    (result, List.drop 1 randomFloats, newArray)
        in
            push result <| shuffle newRandomFloats newArray


unsafeHead : List a -> a
unsafeHead list =
    case List.head list of
        Just something ->
            something

        Nothing ->
            Debug.crash "Empty array"


unsafeUnwrap : Maybe a -> a
unsafeUnwrap maybe =
    case maybe of
        Just something ->
            something

        Nothing -> 
            Debug.crash "Maybe turned out to be nothing"