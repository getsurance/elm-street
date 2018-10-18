port module ElmStreet.Main exposing (..)

import Html exposing (Html, Attribute, button, div, text, program, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Json.Decode as Decode
import ElmStreet.AutocompletePrediction exposing (AutocompletePrediction)
import ElmStreet.Place exposing (Place, ComponentType(..), getComponentName)


type alias Model =
    { streetAddress : String
    , suggestions : List AutocompletePrediction
    , selectedPlace : Maybe Place
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [] Nothing, Cmd.none )


port predictAddress : String -> Cmd msg


port addressPredictions : (Decode.Value -> msg) -> Sub msg


port getAddressDetails : String -> Cmd msg


port addressDetails : (String -> msg) -> Sub msg


type Msg
    = ChangeAddr String
    | AddressPredictions Decode.Value
    | DidSelectAddress String
    | AddressDetails String


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ case model.selectedPlace of
                Just place ->
                    getComponentName place Locality |> Maybe.withDefault "No city for this place" |> text

                Nothing ->
                    text "Select a place"
            ]
        , div [] [ text "Input address" ]
        , input [ placeholder "Address", value model.streetAddress, onInput ChangeAddr ] []
        , div [] (List.map addressView model.suggestions)
        ]


addressView : AutocompletePrediction -> Html Msg
addressView suggestion =
    div [ onClick (DidSelectAddress suggestion.placeId) ] [ text suggestion.description ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeAddr text ->
            ( { model | streetAddress = text }, predictAddress text )

        DidSelectAddress placeId ->
            model ! [ getAddressDetails placeId ]

        AddressDetails placeJson ->
            let
                decodedResult =
                    Decode.decodeString ElmStreet.Place.decoder placeJson
            in
                case decodedResult of
                    Ok place ->
                        { model | streetAddress = place.formattedAddress, selectedPlace = Just place } ! []

                    Err _ ->
                        model ! []

        AddressPredictions predictions ->
            let
                decodedResult =
                    Decode.decodeValue ElmStreet.AutocompletePrediction.decodeList predictions
            in
                case decodedResult of
                    Ok suggestions ->
                        { model | suggestions = suggestions } ! []

                    Err _ ->
                        model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ addressPredictions AddressPredictions, addressDetails AddressDetails ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
