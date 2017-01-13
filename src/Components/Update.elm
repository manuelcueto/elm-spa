module Components.Update exposing (..)

import Components.Messages exposing (..)
import Components.Models exposing (..)
import Components.ToDos.Update as ToDoUpdate
import Components.Owner.Update as OwnerUpdate
import Components.Routing exposing (parseLocation)

update : AppMsg -> Model -> (Model, Cmd AppMsg)
update msg {toDos, inputValue, owner, route} =
    case msg of
        ToDosMsg subMsg ->
            let (tasks, input, cmd) = ToDoUpdate.update subMsg toDos inputValue
            in (Model tasks input owner route, cmd)
        OwnerMsg subMsg ->
            let (newOwner, cmd) = OwnerUpdate.update subMsg owner
            in (Model toDos inputValue newOwner route, cmd)
        OnLocationChange location ->
            let newRoute = parseLocation location
            in ( Model toDos inputValue owner newRoute, Cmd.none )

