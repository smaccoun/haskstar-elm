module Server.ResourceAPI exposing (..)

import Json.Decode exposing (Decoder, string)
import RemoteData exposing (WebData)
import Server.Config exposing (Context)
import Server.RequestUtils exposing (Endpoint(..), getRequest, postRequest)


getContainer : Context -> Endpoint -> Decoder a -> Cmd (WebData a)
getContainer context (Endpoint endpoint) decoder =
    getRequest context
        endpoint
        decoder
        |> RemoteData.sendRequest
