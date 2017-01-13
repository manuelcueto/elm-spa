module Components.View exposing (..)

import Components.Messages exposing (..)
import Components.Models exposing (..)
import Components.Owner.Models exposing (Owner)
import Components.Owner.Messages as OwnerMessages exposing (..)
import Html exposing (Html, div, text, form, input, button, span)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Components.ToDos.View as ToDoView
import Components.ToDos.EditView as EditToDoView
import Components.Routing exposing (Route(..))

view : Model -> Html AppMsg
view model =

    div [id "page-container"]
        [navBar, page model]

navBar : Html AppMsg
navBar =
    div [id "navBar"]
    [ span [class "pull-left"] [text "ToDo List"]
    , span [class "pull-right clickable", onClick (OwnerMsg AboutMe) ] [text "whoami"]
    ]
page : Model -> Html AppMsg
page model =
    case model.route of
        ToDosRoute ->
            Html.map (\a -> a) (ToDoView.view model.toDos model.inputValue)
        ToDoRoute id ->
            toDoEditView model id
        MeRoute ->
            me model.owner
        NotFoundRoute ->
            notFoundView


    -- ToDosMsg : AppMsg  (ToDoMessages.Msg -> AppMsg)

toDoEditView :  Model -> Int -> Html AppMsg
toDoEditView model toDoId =
    let
        maybeToDo =
            model.toDos
                |> List.filter (\toDo -> toDo.id == toDoId)
                |> List.head
    in
        case maybeToDo of
            Just toDo ->
                Html.map ToDosMsg (EditToDoView.view toDo)
            Nothing ->
                notFoundView

notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]

me : Owner -> Html AppMsg
me owner =
    div [] [
        Html.form [id "form"] [
            input [placeholder "name", onInput (inputForMessage NameChange), value owner.name] []
            , input [placeholder "email", onInput (inputForMessage EmailChange), value owner.email] []
            , input [placeholder "age", onInput (inputForMessage AgeChange), value (toString owner.age)] []
            , button [onClick (OwnerMsg (Change owner))] [text "update owner"]
        ]
    ]

inputForMessage : (String -> OwnerMsg) -> (String -> AppMsg)
inputForMessage subMsg =
    \input -> OwnerMsg (subMsg (input))