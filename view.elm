module View exposing (view)

import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Update exposing (Msg)
import Styles


view : Model -> Html Msg
view model =
    div [ style Styles.container ] 
        [ h1 [] [ text "memory" ]
        , div [ style Styles.imagesContainer ] 
            <| toList <| indexedMap cardView model.cards
        ]

cardView : Int -> Card -> Html Msg
cardView index card = 
    let
        isHidden = not (card.found || card.turned)
        action = if card.found || card.turned then NoOp else Turn index
    in
        button 
            [ onClick action, style Styles.imageContainer ] 
            [ img 
                [ src card.imageSource
                , style Styles.image
                , hidden isHidden 
                ] 
            [] ]