module Components.ToDos.Commands exposing (..)

import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Components.ToDos.Models as Model exposing (..)
import Components.ToDos.Messages exposing (..)
import Components.Messages exposing (..)
import RestApi exposing (..)


--urls

fetchAllUrl : Url
fetchAllUrl = "http://localhost:9000/todos"

updateUrl : Int -> Url
updateUrl id =
    "http://localhost:9000/todos/" ++ toString id

deleteUrl : Int -> Url
deleteUrl id =
    "http://localhost:9000/todos/" ++ toString id

saveUrl : Url
saveUrl = "http://localhost:9000/todos"


--Crud

fetchAll : Cmd AppMsg
fetchAll =
    RestApi.fetchAll fetchAllUrl collectionDecoder (\response -> ToDosMsg <| OnFetchAll response)

update : ToDo -> Cmd AppMsg
update toDo =
    let
        url = updateUrl toDo.id
        body = memberEncoded toDo
        cmd = \response -> ToDosMsg <| OnUpdate <| response
        decoder = \code -> String.toInt code |> Result.toMaybe |> Maybe.withDefault toDo.id
    in
        RestApi.update url body decoder cmd

save : ToDo -> Cmd AppMsg
save toDo =
    let
        body = memberEncoded toDo
        cmd = \response -> ToDosMsg <| OnSave response
        decoder = \body -> case Decode.decodeString memberDecoder body of
                                Ok todo -> todo
                                Err _ -> toDo
    in
        RestApi.save saveUrl body decoder cmd


delete : ToDo -> Cmd AppMsg
delete toDo =
    let
        body = memberEncoded toDo
        url = deleteUrl toDo.id
        decoder = \code -> String.toInt code |> Result.toMaybe |> Maybe.withDefault toDo.id
        cmd = \response -> ToDosMsg <| OnDelete <| response
    in
        RestApi.delete url body decoder cmd
--request methods


memberEncoded : ToDo -> Encode.Value
memberEncoded toDo =
    let
        list =
            [ ( "id", Encode.int toDo.id )
            , ( "task", Encode.string toDo.task )
            , ( "completed", Encode.bool toDo.completed )
            ]
    in
        list
            |> Encode.object


collectionDecoder : Decode.Decoder (List Model.ToDo)
collectionDecoder =
    Decode.list memberDecoder

memberDecoder : Decode.Decoder Model.ToDo
memberDecoder =
    Decode.map3 Model.ToDo
        (field "task" Decode.string)
        (field "completed" Decode.bool)
        (field "id" Decode.int)