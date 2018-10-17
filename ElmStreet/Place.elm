module ElmStreet.Place exposing (Place, LatLng, LatLngBounds, AddressComponent, Geometry, decodePlace)

{-| Types for Google places api


# Type aliases

@docs Place, LatLng, LatLngBounds, AddressComponent, Geometry


# Decoding

@docs decodePlace

-}

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


{-| Google object [PlaceResult][pr]

[pr]: https://developers.google.com/maps/documentation/javascript/reference/places-service#PlaceResult

-}
type alias Place =
    { addressComponents : List AddressComponent
    , adrAddress : String
    , formattedAddress : String
    , geometry : Geometry
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


{-| [LatLng][ll] coordinates

[ll]: https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLng

-}
type alias LatLng =
    { lat : Float
    , lng : Float
    }


{-| [LatLngBouns][llb] coordinates

[llb]: https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLngBounds

-}
type alias LatLngBounds =
    { south : Float
    , west : Float
    , north : Float
    , east : Float
    }


{-| Google object [PlaceGeometry][pg]

[pg]: https://developers.google.com/maps/documentation/javascript/reference/places-service#PlaceGeometry

-}
type alias Geometry =
    { location : LatLng
    , viewport : LatLngBounds
    }


{-| Google object [Address Component][ac]

[ac]: https://developers.google.com/maps/documentation/javascript/reference/geocoder#GeocoderAddressComponent

-}
type alias AddressComponent =
    { long_name : String
    , short_name : String
    , types : List String
    }


{-| Pass through ports an object of type [PlaceResult][pr]

[pr]: https://developers.google.com/maps/documentation/javascript/reference/places-service#PlaceResult

-}
decodePlace : Json.Decode.Decoder Place
decodePlace =
    Json.Decode.Pipeline.decode Place
        |> Json.Decode.Pipeline.required "address_components" (Json.Decode.list decodeAddressComponent)
        |> Json.Decode.Pipeline.required "adr_address" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "formatted_address" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "geometry" (decodeGeometry)
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


decodeAddressComponent : Json.Decode.Decoder AddressComponent
decodeAddressComponent =
    Json.Decode.Pipeline.decode AddressComponent
        |> Json.Decode.Pipeline.required "long_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "short_name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)


decodeLatLng : Json.Decode.Decoder LatLng
decodeLatLng =
    Json.Decode.Pipeline.decode LatLng
        |> Json.Decode.Pipeline.required "lat" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "lng" (Json.Decode.float)


decodeLatLngBounds : Json.Decode.Decoder LatLngBounds
decodeLatLngBounds =
    Json.Decode.Pipeline.decode LatLngBounds
        |> Json.Decode.Pipeline.required "south" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "west" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "north" (Json.Decode.float)
        |> Json.Decode.Pipeline.required "east" (Json.Decode.float)


decodeGeometry : Json.Decode.Decoder Geometry
decodeGeometry =
    Json.Decode.Pipeline.decode Geometry
        |> Json.Decode.Pipeline.required "location" (decodeLatLng)
        |> Json.Decode.Pipeline.required "viewport" (decodeLatLngBounds)
