port module Ports exposing (addressDetails, addressPredictions, getPredictionDetails, predictAddress)

import Json.Decode as Decode


port predictAddress : String -> Cmd msg


port addressPredictions : (Decode.Value -> msg) -> Sub msg


port getPredictionDetails : String -> Cmd msg


port addressDetails : (String -> msg) -> Sub msg
