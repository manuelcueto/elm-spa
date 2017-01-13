module Components.ToDos.Models exposing (..)

type alias ToDo =
    {  task : String,
       completed : Bool,
       id : Int
    }
