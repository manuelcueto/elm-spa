module Components.ToDos.Messages exposing (..)

import Http
import Components.ToDos.Models exposing (ToDo)
type Msg
    = NoOp
    | ToDo
    | Input String
    | Complete Int
    | Delete Int
    | OnFetchAll (Result  Http.Error (List ToDo))
    | OnSave (Result Http.Error ToDo)
    | OnUpdate (Result Http.Error Int)
    | OnDelete (Result Http.Error Int)

