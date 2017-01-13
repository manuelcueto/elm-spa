module Components.Models exposing (..)

import Components.ToDos.Models exposing (ToDo)
import Components.Owner.Models exposing (Owner)
import Components.Routing exposing (Route)

type alias Model =
    { toDos : List ToDo,
      inputValue : String,
      owner : Owner,
      route : Route
    }


initialModel : Route -> Model
initialModel route =
    { toDos = [],
      inputValue = "",
      owner = Owner "Manuel" "manuel.redb.ee" 21,
      route = route
    }