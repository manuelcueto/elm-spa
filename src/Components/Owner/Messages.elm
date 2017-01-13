module Components.Owner.Messages exposing (..)

import Components.Owner.Models exposing (..)

type OwnerMsg
    = NoOp
    | Change Owner
    | AgeChange String
    | NameChange String
    | EmailChange String
    | AboutMe


