module Main exposing (Model, Msg(..), addressView, init, main, subscriptions, update, view)

import Browser
import ElmStreet.AutocompletePrediction exposing (AutocompletePrediction)
import ElmStreet.Place exposing (ComponentType(..), Place, getComponentName)
import Html exposing (Attribute, Html, button, div, img, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Ports exposing (..)


type alias Model =
    { streetAddress : String
    , suggestions : List AutocompletePrediction
    , selectedPlace : Maybe Place
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" [] Nothing, Cmd.none )


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
                    getComponentName place Locality
                        |> Maybe.withDefault "none"
                        |> String.append "Selected city: "
                        |> text

                Nothing ->
                    text ""
            ]
        , input [ placeholder "Address", value model.streetAddress, onInput ChangeAddr ] []
        , div [] (List.map addressView model.suggestions)
        , img [ src "https://developers.google.com/places/documentation/images/powered-by-google-on-white.png" ] []
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
            , getPredictionDetails placeId
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


main : Program Decode.Value Model Msg
main =
    Browser.element
        { init = always init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
