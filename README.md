
# elm-street

Type alias in Elm for [Google Places Autocomplete javascript api](https://developers.google.com/maps/documentation/javascript/places). 

## Basic Usage

Create ports to comunicate with AutocompleteService:
```elm
port predictAddress : String -> Cmd msg


port addressPredictions : (Json.Decode.Value -> msg) -> Sub msg
```

```javascript
app.ports.predictAddress.subscribe(function(text) {
  if(!text) { return; }
  var service = new google.maps.places.AutocompleteService();
  var options = { input: text, componentRestrictions: {country: "de"}, types: ['address'] }
  service.getPlacePredictions(options, function(predictions, status) {
    app.ports.addressPredictions.send(predictions);
  });
});
```

Decode prediction using elm-street inside Elm:
```elm
decodedResult =
    Json.Decode.decodeValue (ElmStreet.AutocompletePrediction.decodeList) predictions
```

## Policies

Please follow the Google Places API when using this package:
<https://developers.google.com/places/web-service/policies>

## Examples

This project contains an example showing how to use the package.

To compile to example:
```
cd Example
elm make Main.elm --output main.js
```

Serve and open index.html.

## Todo
- [x] Create decoders for autocomplete response object inside Elm
- [ ] Add a autocomplete dropdown as UI element
- [ ] Pass service options from inside Elm
- [ ] Decode AddressComponents into fixed types instead of a list, making impossible states impossible

## Acknowledgement

Thanks [labzero/elm-google-geocoding](https://github.com/labzero/elm-google-geocoding) for the inspiration for this package.
