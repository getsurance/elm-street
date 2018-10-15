port module Main exposing (..)

import Html exposing (Html, Attribute, button, div, text, program, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode
import AutocompletePrediction


-- MODEL


type alias Model =
    { streetAddress : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


port predict : String -> Cmd msg


port placeSuggestion : (Json.Decode.Value -> msg) -> Sub msg


type Msg
    = ChangeAddr String
    | NewSuggestion Json.Decode.Value


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Address", value model.streetAddress, onInput ChangeAddr ] []
        , div [] [ text "Input address" ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeAddr text ->
            ( { model | streetAddress = text }, predict text )

        NewSuggestion predictions ->
            let
                decodedResult =
                    Json.Decode.decodeValue (Json.Decode.list AutocompletePrediction.decodeAutocompletePrediction) predictions

                _ =
                    Debug.log "decoder" decodedResult
            in
                model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    placeSuggestion NewSuggestion



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
