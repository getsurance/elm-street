module AutocompletePrediction exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


type alias AutocompletePrediction =
    { description : String
    , id : String
    , matchedSubstrings : List MatchedSubstring
    , placeId : String
    , reference : String
    , structuredFormatting : StructuredFormatting
    , terms : List Term
    , types : List String
    }


type alias StructuredFormatting =
    { mainText : String
    , mainTextMatchedSubstrings : List MatchedSubstring
    , secondaryText : String
    }


type alias Term =
    { offset : Int
    , value : String
    }


type alias MatchedSubstring =
    { length : Int
    , offset : Int
    }


decodeTerm : Json.Decode.Decoder Term
decodeTerm =
    Json.Decode.Pipeline.decode Term
        |> Json.Decode.Pipeline.required "offset" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "value" (Json.Decode.string)


decodeMatchedSubstring : Json.Decode.Decoder MatchedSubstring
decodeMatchedSubstring =
    Json.Decode.Pipeline.decode MatchedSubstring
        |> Json.Decode.Pipeline.required "length" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "offset" (Json.Decode.int)


decodeAutocompletePrediction : Json.Decode.Decoder AutocompletePrediction
decodeAutocompletePrediction =
    Json.Decode.Pipeline.decode AutocompletePrediction
        |> Json.Decode.Pipeline.required "description" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "matched_substrings" (Json.Decode.list decodeMatchedSubstring)
        |> Json.Decode.Pipeline.required "place_id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "reference" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "structured_formatting" (decodeStructuredFormatting)
        |> Json.Decode.Pipeline.required "terms" (Json.Decode.list decodeTerm)
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)


decodeStructuredFormatting : Json.Decode.Decoder StructuredFormatting
decodeStructuredFormatting =
    Json.Decode.Pipeline.decode StructuredFormatting
        |> Json.Decode.Pipeline.required "main_text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "main_text_matched_substrings" (Json.Decode.list decodeMatchedSubstring)
        |> Json.Decode.Pipeline.required "secondary_text" (Json.Decode.string)
