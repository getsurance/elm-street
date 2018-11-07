module ElmStreet.Place exposing
    ( Place, LatLng, LatLngBounds, AddressComponent, Geometry, ComponentType(..)
    , decoder
    , getComponentName
    )

{-| Types for Google places api


# Type aliases

@docs Place, LatLng, LatLngBounds, AddressComponent, Geometry, ComponentType


# Decoding

@docs decoder


# Helper

@docs getComponentName

-}

import Dict exposing (Dict)
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


{-| Type alias for [PlaceResult][pr]

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


{-| Type alias for [LatLng][ll] coordinates

[ll]: https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLng

-}
type alias LatLng =
    { lat : Float
    , lng : Float
    }


{-| Type alias for [LatLngBouns][llb]

[llb]: https://developers.google.com/maps/documentation/javascript/reference/coordinates#LatLngBounds

-}
type alias LatLngBounds =
    { south : Float
    , west : Float
    , north : Float
    , east : Float
    }


{-| Type alias for [PlaceGeometry][pg]

[pg]: https://developers.google.com/maps/documentation/javascript/reference/places-service#PlaceGeometry

-}
type alias Geometry =
    { location : LatLng
    , viewport : LatLngBounds
    }


{-| Type alias for [GeocoderAddressComponent][ac]

[ac]: https://developers.google.com/maps/documentation/javascript/reference/geocoder#GeocoderAddressComponent

-}
type alias AddressComponent =
    { long_name : String
    , short_name : String
    , types : List ComponentType
    }


{-| [Types][ty] for address component

[ty]: https://developers.google.com/maps/documentation/geocoding/intro#Types

-}
type ComponentType
    = StreetAddress
    | Route
    | Intersection
    | Political
    | Country
    | AdministrativeAreaLevel1
    | AdministrativeAreaLevel2
    | AdministrativeAreaLevel3
    | AdministrativeAreaLevel4
    | AdministrativeAreaLevel5
    | ColloquialArea
    | Locality
    | Sublocality
    | SublocalityLevel1
    | SublocalityLevel2
    | SublocalityLevel3
    | SublocalityLevel4
    | SublocalityLevel5
    | Neighborhood
    | Premise
    | Subpremise
    | PostalCode
    | NaturalFeature
    | Airport
    | Park
    | PostBox
    | StreetNumber
    | Floor
    | Room
    | Establishment
    | PointOfInterest
    | Parking
    | PostalTown
    | BusStation
    | TrainStation
    | TransitStation
    | PostalCodeSuffix
    | OtherComponent


{-| Decoder for objects of type [PlaceResult][pr]

[pr]: https://developers.google.com/maps/documentation/javascript/reference/places-service#PlaceResult

-}
decoder : Json.Decode.Decoder Place
decoder =
    Json.Decode.succeed Place
        |> Json.Decode.Pipeline.required "address_components" (Json.Decode.list decodeAddressComponent)
        |> Json.Decode.Pipeline.required "adr_address" Json.Decode.string
        |> Json.Decode.Pipeline.required "formatted_address" Json.Decode.string
        |> Json.Decode.Pipeline.required "geometry" decodeGeometry
        |> Json.Decode.Pipeline.required "icon" Json.Decode.string
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "place_id" Json.Decode.string
        |> Json.Decode.Pipeline.required "reference" Json.Decode.string
        |> Json.Decode.Pipeline.required "scope" Json.Decode.string
        |> Json.Decode.Pipeline.required "types" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "url" Json.Decode.string
        |> Json.Decode.Pipeline.required "utc_offset" Json.Decode.int
        |> Json.Decode.Pipeline.required "vicinity" Json.Decode.string


{-| Helper function to name by components type.
-}
getComponentName : Place -> ComponentType -> Maybe String
getComponentName place componentType =
    place.addressComponents |> List.filter (\c -> List.member componentType c.types) |> List.head |> Maybe.map .long_name


componentTypeList : List ( String, ComponentType )
componentTypeList =
    [ ( "street_address", StreetAddress )
    , ( "route", Route )
    , ( "intersection", Intersection )
    , ( "political", Political )
    , ( "country", Country )
    , ( "administrative_area_level_1", AdministrativeAreaLevel1 )
    , ( "administrative_area_level_2", AdministrativeAreaLevel2 )
    , ( "administrative_area_level_3", AdministrativeAreaLevel3 )
    , ( "administrative_area_level_4", AdministrativeAreaLevel4 )
    , ( "administrative_area_level_5", AdministrativeAreaLevel5 )
    , ( "colloquial_area", ColloquialArea )
    , ( "locality", Locality )
    , ( "sublocality", Sublocality )
    , ( "sublocality_level_1", SublocalityLevel1 )
    , ( "sublocality_level_2", SublocalityLevel2 )
    , ( "sublocality_level_3", SublocalityLevel3 )
    , ( "sublocality_level_4", SublocalityLevel4 )
    , ( "sublocality_level_5", SublocalityLevel5 )
    , ( "neighborhood", Neighborhood )
    , ( "premise", Premise )
    , ( "subpremise", Subpremise )
    , ( "postal_code", PostalCode )
    , ( "natural_feature", NaturalFeature )
    , ( "airport", Airport )
    , ( "park", Park )
    , ( "post_box", PostBox )
    , ( "street_number", StreetNumber )
    , ( "floor", Floor )
    , ( "room", Room )
    , ( "establishment", Establishment )
    , ( "point_of_interest", PointOfInterest )
    , ( "parking", Parking )
    , ( "postal_town", PostalTown )
    , ( "bus_station", BusStation )
    , ( "train_station", TrainStation )
    , ( "transit_station", TransitStation )
    , ( "postal_code_suffix", PostalCodeSuffix )
    ]


decodeAddressComponent : Json.Decode.Decoder AddressComponent
decodeAddressComponent =
    Json.Decode.succeed AddressComponent
        |> Json.Decode.Pipeline.required "long_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "short_name" Json.Decode.string
        |> Json.Decode.Pipeline.required "types" typeListDecoder


decodeLatLng : Json.Decode.Decoder LatLng
decodeLatLng =
    Json.Decode.succeed LatLng
        |> Json.Decode.Pipeline.required "lat" Json.Decode.float
        |> Json.Decode.Pipeline.required "lng" Json.Decode.float


decodeLatLngBounds : Json.Decode.Decoder LatLngBounds
decodeLatLngBounds =
    Json.Decode.succeed LatLngBounds
        |> Json.Decode.Pipeline.required "south" Json.Decode.float
        |> Json.Decode.Pipeline.required "west" Json.Decode.float
        |> Json.Decode.Pipeline.required "north" Json.Decode.float
        |> Json.Decode.Pipeline.required "east" Json.Decode.float


decodeGeometry : Json.Decode.Decoder Geometry
decodeGeometry =
    Json.Decode.succeed Geometry
        |> Json.Decode.Pipeline.required "location" decodeLatLng
        |> Json.Decode.Pipeline.required "viewport" decodeLatLngBounds


typeListDecoder : Json.Decode.Decoder (List ComponentType)
typeListDecoder =
    Json.Decode.list typeDecoder


typeDecoder : Json.Decode.Decoder ComponentType
typeDecoder =
    Json.Decode.string |> Json.Decode.andThen mapComponentType


componentTypeMap : Dict String ComponentType
componentTypeMap =
    Dict.fromList componentTypeList


mapComponentType : String -> Json.Decode.Decoder ComponentType
mapComponentType =
    Json.Decode.succeed << stringToComponentType


stringToComponentType : String -> ComponentType
stringToComponentType str =
    Dict.get str componentTypeMap
        |> Maybe.withDefault OtherComponent
