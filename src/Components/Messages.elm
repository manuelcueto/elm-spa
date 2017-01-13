module Components.Messages exposing (..)

import Components.ToDos.Messages as ToDoMessages
import Components.Owner.Messages as OwnerMessage
import Navigation exposing (Location)

type AppMsg
    = ToDosMsg ToDoMessages.Msg
        | OwnerMsg OwnerMessage.OwnerMsg
        | OnLocationChange Location