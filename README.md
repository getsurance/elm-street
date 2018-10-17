
# Markdown in Elm

Types for Google Places Autocomplete javascript api.

## Basic Usage

Create ports to comunicate with AutocompleteService:
```elm
port predict : String -> Cmd msg


port placeSuggestion : (Json.Decode.Value -> msg) -> Sub msg
```

```javascript
    app.ports.predict.subscribe(function(text) {
      if(!text) { return; }
      var service = new google.maps.places.AutocompleteService();
      var options = { input: text, componentRestrictions: {country: "de"}, types: ['address'] }
      service.getPlacePredictions(options, function(predictions, status) {
        app.ports.placeSuggestion.send(predictions);
      });
    });
```

Decode prediction using elm-street inside Elm:
```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewSuggestion predictions ->
            let
                decodedResult =
                    Json.Decode.decodeValue (Json.Decode.list AutocompletePrediction.decodeAutocompletePrediction) predictions
            in
                case decodedResult of
                    Ok suggestions ->
                        { model | suggestions = suggestions } ! []

                    Err _ ->
                        model ! []
```

## Examples

This repo contains an example showing how to use the package.

Just compile Main.elm, serve and open index.html.

## Todo
- [x] Decodable Json inside Elm
- [ ] Decode address components into fixed types instead of a list, making impossible states impossible
- [ ] Add a autocomplete dropdown as UI element
- [ ] Pass service configuration from Elm

