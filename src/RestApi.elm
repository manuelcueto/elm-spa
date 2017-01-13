module RestApi exposing (..)

import Json.Decode exposing (..)
import Json.Encode as Encode exposing (..)
import Http exposing (..)

type alias Action = String
type RestVerb = Put
              | Post
              | Delete

type alias Url = String

type alias DecoderFunc a = String -> a
type alias CommandAction a msg = (Result Error a -> msg)

--get : url, decoder, cmd
fetchAll : Url -> Decoder a -> CommandAction a msg -> Cmd msg
fetchAll url decoder sendCmd =
    Http.get url decoder
        |> Http.send sendCmd


update : Url -> Encode.Value -> DecoderFunc b -> CommandAction b msg -> Cmd msg
update url body decoder sendCmd =
    let
        request = buildRequest body url Put decoder
    in
        Http.send sendCmd request


delete : Url -> Encode.Value -> DecoderFunc b -> CommandAction b msg -> Cmd msg
delete url body decoder sendCmd =
    let
        request = buildRequest body url Delete decoder
    in
        Http.send sendCmd request

save : Url -> Encode.Value -> DecoderFunc b -> CommandAction b msg -> Cmd msg
save url body decoder sendCmd =
    let
        request = buildRequest body url Post decoder
    in
        Http.send sendCmd request




--save : ToDo -> Cmd AppMsg
--save toDo =
--    buildRequest toDo saveUrl Post
--        |> Http.send (\response -> ToDosMsg <| OnSave response)
--



buildRequest : Encode.Value -> Url -> RestVerb -> DecoderFunc a -> Http.Request a
buildRequest body url action decoder =
    case action of
        Put ->
            buildHttpRequest body url "PUT" decoder
        Post ->
            buildHttpRequest body url "POST" decoder
        Delete ->
            buildHttpRequest body url "DELETE" decoder

buildHttpRequest : Encode.Value -> Url -> Action -> DecoderFunc a -> Http.Request a
buildHttpRequest body url action decoder =
    Http.request
            { body = body |> Http.jsonBody
            , expect = Http.expectStringResponse <| \response -> Ok <| decoder <| response.body
            , headers = []
            , method = action
            , timeout = Nothing
            , url = url
            , withCredentials = False
            }
