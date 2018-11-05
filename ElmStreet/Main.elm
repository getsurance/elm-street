port module ElmStreet.Main exposing (Model, Msg(..), addressDetails, addressPredictions, addressView, getAddressDetails, init, main, predictAddress, subscriptions, update, view)

import Browser
import ElmStreet.AutocompletePrediction exposing (AutocompletePrediction)
import ElmStreet.Place exposing (ComponentType(..), Place, getComponentName)
import Html exposing (Attribute, Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode


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
            ( model
            , getAddressDetails placeId
            )

        AddressDetails placeJson ->
            let
                decodedResult =
                    Decode.decodeString ElmStreet.Place.decoder placeJson
            in
            case decodedResult of
                Ok place ->
                    ( { model | streetAddress = place.formattedAddress, selectedPlace = Just place }
                    , Cmd.none
                    )

                Err _ ->
                    ( model
                    , Cmd.none
                    )

        AddressPredictions predictions ->
            let
                decodedResult =
                    Decode.decodeValue ElmStreet.AutocompletePrediction.decodeList predictions
            in
            case decodedResult of
                Ok suggestions ->
                    ( { model | suggestions = suggestions }
                    , Cmd.none
                    )

                Err _ ->
                    ( model
                    , Cmd.none
                    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ addressPredictions AddressPredictions, addressDetails AddressDetails ]


main : Program Never Model Msg
main =
    Brower.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
