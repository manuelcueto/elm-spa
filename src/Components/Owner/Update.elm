module Components.Owner.Update exposing (..)

import Components.Owner.Messages as Message exposing (..)
import Components.Messages exposing (..)
import Components.Owner.Models as Model exposing (..)
import Debug exposing (log)
import Navigation exposing (newUrl)

update : OwnerMsg -> Owner -> (Owner, Cmd AppMsg)
update msg actualOwner =
    case msg of
        NoOp ->
            (defaultOwner, Cmd.none)
        Change newOwner ->  {-- add validation --}
            (log "string" newOwner, Cmd.none)
        AgeChange input ->
            ( { actualOwner | age = safeToInt input }, Cmd.none)
        NameChange input ->
            ( { actualOwner | name = input }, Cmd.none)
        EmailChange input ->
            ( { actualOwner | email = input }, Cmd.none)
        AboutMe ->
            (actualOwner, Navigation.newUrl "#me" )


defaultOwner : Owner
defaultOwner = Owner "manuel"  "sarlanga" 21

safeToInt : String -> Int
safeToInt = String.toInt >> Result.toMaybe >> Maybe.withDefault 0