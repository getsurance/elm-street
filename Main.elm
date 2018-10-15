port module Main exposing (..)

import Html exposing (Html, Attribute, button, div, text, program, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode
import AutocompletePrediction exposing (AutocompletePrediction)


type alias Model =
    { streetAddress : String
    , suggestions : List AutocompletePrediction
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [], Cmd.none )


port predict : String -> Cmd msg


port placeSuggestion : (Json.Decode.Value -> msg) -> Sub msg


type Msg
    = ChangeAddr String
    | NewSuggestion Json.Decode.Value


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Input address" ]
        , input [ placeholder "Address", value model.streetAddress, onInput ChangeAddr ] []
        , div [] (List.map addressView model.suggestions)
        ]


addressView : AutocompletePrediction -> Html Msg
addressView suggestion =
    div [] [ text suggestion.description ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeAddr text ->
            ( { model | streetAddress = text }, predict text )

        NewSuggestion predictions ->
            let
                decodedResult =
                    Json.Decode.decodeValue (Json.Decode.list AutocompletePrediction.decodeAutocompletePrediction) predictions
            in
                case decodedResult of
                    Ok suggestions ->
                        { model | suggestions = suggestions } ! []

                    Err _ ->
                        model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    placeSuggestion NewSuggestion


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
