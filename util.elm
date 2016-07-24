module Util exposing (..)

import Array exposing (..)


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


id : a -> () -> a
id a = \_ -> a            