module Server.ResourceAPI exposing (..)

import Http exposing (jsonBody)
import Json.Decode exposing (Decoder, string)
import Json.Encode exposing (Value)
import RemoteData exposing (WebData)
import Server.Config exposing (Context)
import Server.RequestUtils exposing (Endpoint(..), getRequest, postRequest)


type BaseRequestParams a
    = BaseRequestParams Context Endpoint (Decoder a)


type alias RemoteCmd a =
    Cmd (WebData a)


getContainer : BaseRequestParams (List a) -> RemoteCmd (List a)
getContainer (BaseRequestParams context (Endpoint endpoint) decoder) =
    getRequest context
        endpoint
        decoder
        |> RemoteData.sendRequest


getItem : BaseRequestParams a -> String -> RemoteCmd a
getItem (BaseRequestParams context (Endpoint endpoint) decoder) uuid =
    getRequest context
        (endpoint ++ "/" ++ uuid)
        decoder
        |> RemoteData.sendRequest


createItem : BaseRequestParams a -> Value -> RemoteCmd a
createItem (BaseRequestParams context (Endpoint endpoint) decoder) encodedValue =
    postRequest context
        endpoint
        (jsonBody encodedValue)
        decoder
        |> RemoteData.sendRequest


updateItem : BaseRequestParams a -> Value -> String -> RemoteCmd a
updateItem (BaseRequestParams context (Endpoint endpoint) decoder) encodedValue uuid =
    postRequest context
        (endpoint ++ "/update/" ++ uuid)
        (jsonBody encodedValue)
        decoder
        |> RemoteData.sendRequest
