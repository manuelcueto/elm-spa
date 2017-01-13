module Components.ToDos.View exposing (..)

import Components.ToDos.Models exposing (..)
import Components.ToDos.Messages as ToDoMessage
import Components.Messages as AppMsg exposing (..)
import Html exposing (Html, div, text, program, li, ul, input, button, Attribute, form)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


view : List ToDo -> String -> Html AppMsg
view toDos inputValue =
    div [class "no-padding"]
    [div [class "button-container some-padding"] [
                 input [ placeholder "new Task", onInput <| \input -> AppMsg.ToDosMsg <| ToDoMessage.Input <| input, value inputValue] []
                 , button [ onClick (AppMsg.ToDosMsg ToDoMessage.ToDo)] [text "Add New Task"]
             ]
     ,generateList toDos
    ]

generateList : List ToDo -> Html AppMsg
generateList messages =
    div [] (List.map addTodo messages)

addTodo : ToDo -> Html AppMsg
addTodo toDo =
    div [id "todo-container"]
        [ div [id "todo-label"] [text toDo.task]
        , div [id "delete", class "pull-right no-padding clickable", onClick <| AppMsg.ToDosMsg <| ToDoMessage.Delete <| toDo.id] [text "X"]
        , status toDo.completed toDo.id
        ]


status : Bool -> Int -> Html AppMsg
status completed toDoId =
    case completed of
        True ->
            div [id "todo-action", class "pull-right no-padding"] [
            text "completed"
            ]
        False ->
            div [id "todo-action", class "pull-right no-padding"] [
            button [id "complete", onClick <| AppMsg.ToDosMsg <| ToDoMessage.Complete <| toDoId] [text "complete Task"]
            ]


