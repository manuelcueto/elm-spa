module Components.ToDos.Update exposing (..)

import Components.ToDos.Messages as Message exposing (..)
import Components.ToDos.Models as Model exposing (..)
import Components.ToDos.Commands as Cmds exposing(update)
import Components.Messages exposing(AppMsg)
import List exposing (partition)

update : Msg -> List Model.ToDo -> String -> (List Model.ToDo, String, Cmd AppMsg)
update msg toDos inputValue =
    case msg of
        NoOp ->
            (toDos, inputValue, Cmd.none)
        Message.ToDo ->
            let
                newTask = Model.ToDo inputValue False 1
            in
                (toDos, "", Cmds.save newTask )
        Input input ->
            (toDos, input, Cmd.none)
        Complete id ->
            let
                completeTasks = \todo -> if todo.id == id then Cmds.update {todo | completed = True} else Cmd.none
            in
                (toDos, inputValue, List.map completeTasks toDos |> Cmd.batch)
        Delete id ->
            let
                deleteTasks = \todo -> if todo.id == id then Cmds.delete todo else Cmd.none
            in
                (toDos, inputValue, List.map deleteTasks toDos |> Cmd.batch)
        OnFetchAll (Ok newTodos) ->
            (newTodos, inputValue, Cmd.none)
        OnFetchAll (Err error) ->
            (toDos, inputValue, Cmd.none)
        OnSave (Ok toDo) ->
            (toDo :: toDos, inputValue, Cmd.none)
        OnSave (Err error) ->
            (toDos, inputValue, Cmd.none)
        OnUpdate (Ok toDo) ->
            (updateCompleted toDo toDos, inputValue, Cmd.none)
        OnUpdate (Err error) ->
            (toDos, inputValue, Cmd.none)
        OnDelete (Ok _) ->
            (toDos, inputValue, Cmds.fetchAll)
        OnDelete (Err error) ->
            (toDos, inputValue, Cmd.none)

updateCompleted : Int -> List Model.ToDo -> List Model.ToDo
updateCompleted completed all =
    let
        updater = \toDo -> if toDo.id == completed then { toDo | completed = True } else toDo
    in
        List.map updater all

removeDeleted : Model.ToDo -> List Model.ToDo -> List Model.ToDo
removeDeleted deleted all =
    let
        (removed, remaining) = partition (\toDo -> toDo.id == deleted.id) all
    in
        remaining