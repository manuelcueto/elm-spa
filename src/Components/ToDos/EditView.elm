module Components.ToDos.EditView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href)
import Html.Events exposing (onClick)
import Components.Messages as AppMsg exposing (..)
import Components.ToDos.Messages as Messages exposing (..)
import Components.ToDos.Models exposing (..)


view : ToDo -> Html Msg
view model =
    div []
        [ nav model
        , form model
        ]

nav : ToDo -> Html Msg
nav model =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ text "the task"]

form : ToDo -> Html Msg
form toDo =
    div []
        [ span [] [text toDo.task]
        , button [onClick (Messages.Complete toDo.id)] [text "Complete"]
        ]