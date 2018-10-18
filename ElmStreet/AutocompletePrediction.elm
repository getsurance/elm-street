module ElmStreet.AutocompletePrediction exposing (AutocompletePrediction, StructuredFormatting, PredictionTerm, PredictionSubstring, decoder, decodeList)

{-| Type aliases for Google Autocomplete api


# Type aliases

@docs AutocompletePrediction, StructuredFormatting, PredictionTerm, PredictionSubstring


# Decoding

@docs decoder, decodeList

-}

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


{-| Type alias for objects of type [AutcompletePrediction][ap]

[ap]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#AutocompletePrediction

-}
type alias AutocompletePrediction =
    { description : String
    , id : String
    , matcheSubstrings : List PredictionSubstring
    , placeId : String
    , reference : String
    , structuredFormatting : StructuredFormatting
    , terms : List PredictionTerm
    , types : List String
    }


{-| Type alias for objects of type [StructuredFormatting][sf]

[sf]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#StructuredFormatting

-}
type alias StructuredFormatting =
    { mainText : String
    , mainTextPredictionSubstrings : List PredictionSubstring
    , secondaryText : String
    }


{-| Type alias for objects of type [PredictionPredictionTerm][pt]

[pt]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#PredictionPredictionTerm

-}
type alias PredictionTerm =
    { offset : Int
    , value : String
    }


{-| Type alias for objects of type [PredictionSubstring][ms]

[ms]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#PredictionSubstring

-}
type alias PredictionSubstring =
    { length : Int
    , offset : Int
    }


{-| Decoder for list of [AutcompletePrediction][ap]

[ap]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#AutocompletePrediction

-}
decodeList : Json.Decode.Decoder (List AutocompletePrediction)
decodeList =
    Json.Decode.list decoder


{-| Decoder of [AutcompletePrediction][ap]

[ap]: https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#AutocompletePrediction

-}
decoder : Json.Decode.Decoder AutocompletePrediction
decoder =
    Json.Decode.Pipeline.decode AutocompletePrediction
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "matched_substrings" (Json.Decode.list decodePredictionSubstring)
        |> Json.Decode.Pipeline.required "place_id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "reference" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "structured_formatting" (decodeStructuredFormatting)
        |> Json.Decode.Pipeline.required "terms" (Json.Decode.list decodePredictionTerm)
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)


decodePredictionTerm : Json.Decode.Decoder PredictionTerm
decodePredictionTerm =
    Json.Decode.Pipeline.decode PredictionTerm
        |> Json.Decode.Pipeline.required "offset" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "value" (Json.Decode.string)


decodePredictionSubstring : Json.Decode.Decoder PredictionSubstring
decodePredictionSubstring =
    Json.Decode.Pipeline.decode PredictionSubstring
        |> Json.Decode.Pipeline.required "length" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "offset" (Json.Decode.int)


decodeStructuredFormatting : Json.Decode.Decoder StructuredFormatting
decodeStructuredFormatting =
    Json.Decode.Pipeline.decode StructuredFormatting
        |> Json.Decode.Pipeline.required "main_text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "main_text_matched_substrings" (Json.Decode.list decodePredictionSubstring)
        |> Json.Decode.Pipeline.required "secondary_text" (Json.Decode.string)
