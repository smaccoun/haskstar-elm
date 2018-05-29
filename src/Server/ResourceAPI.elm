module Server.ResourceAPI exposing (..)

import Http exposing (jsonBody)
import Json.Decode exposing (list, string)
import Json.Encode exposing (Value)
import RemoteData exposing (WebData)
import Server.Config exposing (Context, Endpoint(..))
import Server.RequestUtils exposing (BaseRequestParams, getRequest, patchRequest, postRequest)
import Types.MasterEntity exposing (MasterEntity, entityDecoder)
import Types.Pagination exposing (PaginatedResult, paginatedResultDecoder)


type alias RemoteCmd a =
    Cmd (WebData a)


getContainer : BaseRequestParams a -> RemoteCmd (PaginatedResult a)
getContainer { context, endpoint, decoder } =
    getRequest context
        (Endpoint endpoint)
        (paginatedResultDecoder decoder)
        |> RemoteData.sendRequest


getItem : BaseRequestParams a -> String -> RemoteCmd a
getItem { context, endpoint, decoder } uuid =
    getRequest context
        (Endpoint <| endpoint ++ "/" ++ uuid)
        decoder
        |> RemoteData.sendRequest


createItem : BaseRequestParams a -> Value -> RemoteCmd (MasterEntity a)
createItem { context, endpoint, decoder } encodedValue =
    postRequest context
        (Endpoint endpoint)
        (jsonBody encodedValue)
        (entityDecoder decoder)
        |> RemoteData.sendRequest


updateItem : Context -> Endpoint -> Value -> String -> RemoteCmd (List String)
updateItem context (Endpoint endpoint) encodedValue uuid =
    patchRequest context
        (Endpoint <| endpoint ++ "/" ++ uuid)
        (jsonBody encodedValue)
        (list string)
        |> RemoteData.sendRequest
