module Components.Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = ToDosRoute
    | ToDoRoute Int
    | NotFoundRoute
    | MeRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ToDosRoute top
        , map ToDoRoute (s "toDo" </> int)
        , map ToDosRoute (s "toDos")
        , map MeRoute (s "me")
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute