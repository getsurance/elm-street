module Place exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


type alias Place =
    { addressComponents : List AddressComponent
    , adrAddress : String
    , formattedAddress : String
    , geometry : PlaceGeometry
    , icon : String
    , id : String
    , name : String
    , placeId : String
    , reference : String
    , scope : String
    , types : List String
    , url : String
    , utcOffset : Int
    , vicinity : String
    }


type alias PlaceGeometryLocation =
    { lat : Float
    , lng : Float
    }


type alias PlaceGeometryViewport =
    { south : Float
    , west : Float
    , north : Float
    , east : Float
    }


type alias PlaceGeometry =
    { location : PlaceGeometryLocation
    , viewport : PlaceGeometryViewport
    }


type alias AddressComponent =
    { long_name : String
    , short_name : String
    , types : List String
    }


decodeAddressComponent : Json.Decode.Decoder AddressComponent
decodeAddressComponent =
    Json.Decode.Pipeline.decode AddressComponent
        |> Json.Decode.Pipeline.required "long_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "short_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)


decodePlace : Json.Decode.Decoder Place
decodePlace =
    Json.Decode.Pipeline.decode Place
        |> Json.Decode.Pipeline.required "address_components" (Json.Decode.list decodeAddressComponent)
        |> Json.Decode.Pipeline.required "adr_address" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "formatted_address" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "geometry" (decodePlaceGeometry)
        |> Json.Decode.Pipeline.required "icon" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "place_id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "reference" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "scope" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "url" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "utc_offset" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "vicinity" (Json.Decode.string)


decodePlaceGeometryLocation : Json.Decode.Decoder PlaceGeometryLocation
decodePlaceGeometryLocation =
    Json.Decode.Pipeline.decode PlaceGeometryLocation
        |> Json.Decode.Pipeline.required "lat" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "lng" (Json.Decode.float)


decodePlaceGeometryViewport : Json.Decode.Decoder PlaceGeometryViewport
decodePlaceGeometryViewport =
    Json.Decode.Pipeline.decode PlaceGeometryViewport
        |> Json.Decode.Pipeline.required "south" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "west" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "north" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "east" (Json.Decode.float)


decodePlaceGeometry : Json.Decode.Decoder PlaceGeometry
decodePlaceGeometry =
    Json.Decode.Pipeline.decode PlaceGeometry
        |> Json.Decode.Pipeline.required "location" (decodePlaceGeometryLocation)
        |> Json.Decode.Pipeline.required "viewport" (decodePlaceGeometryViewport)
