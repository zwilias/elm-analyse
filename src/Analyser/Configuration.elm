module Analyser.Configuration exposing (..)

import Dict exposing (Dict)
import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))


type alias Configuration =
    { checks : Dict String Bool }


checkEnabled : String -> Configuration -> Bool
checkEnabled k configuration =
    Dict.get k configuration.checks
        |> Maybe.withDefault True


defaultChecks : Dict String Bool
defaultChecks =
    Dict.fromList
        []


defaultConfiguration : Configuration
defaultConfiguration =
    { checks = defaultChecks }


withDefaultChecks : Dict String Bool -> Dict String Bool
withDefaultChecks x =
    Dict.merge
        Dict.insert
        (\k _ b result -> Dict.insert k b result)
        Dict.insert
        defaultChecks
        x
        Dict.empty


mergeWithDefaults : Configuration -> Configuration
mergeWithDefaults { checks } =
    { checks = withDefaultChecks checks
    }


fromString : String -> ( Configuration, List String )
fromString input =
    if input == "" then
        ( defaultConfiguration
        , [ "No configuration provided. Using default configuration." ]
        )
    else
        case JD.decodeString decodeConfiguration input of
            Err e ->
                ( defaultConfiguration
                , [ "Failed to decode defined configuration due to: " ++ e ++ ". Falling back to default configuration" ]
                )

            Ok x ->
                ( mergeWithDefaults x
                , []
                )


decodeConfiguration : Decoder Configuration
decodeConfiguration =
    succeed Configuration
        |: field "checks" decodeChecks


decodeChecks : Decoder (Dict String Bool)
decodeChecks =
    dict bool
