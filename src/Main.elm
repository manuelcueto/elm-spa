module Main exposing (..)

import Components.Messages exposing (..)
import Components.Models exposing (..)
import Components.View exposing (view)
import Components.Update exposing (update)
import Html exposing (Html, div, text, program)
import Components.ToDos.Commands exposing (fetchAll)
import Navigation exposing (Location)
import Components.Routing as Routing exposing (Route)

init : Location -> ( Model, Cmd AppMsg )
init location =
    let
        currentRoute =
           Routing.parseLocation location
    in
        ( initialModel currentRoute, Cmd.map identity fetchAll )


-- Subscriptions

subscriptions :  Model -> Sub AppMsg
subscriptions model =
    Sub.none

-- Main

main : Program Never Model AppMsg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }