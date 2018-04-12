module Server.Api.UserAPI exposing (..)

import RemoteData exposing (WebData)
import Server.Config exposing (apiUrl)
import Server.RequestUtils exposing (getRequest, postRequest)
import Types.User exposing (User, userDecoder)


userEndpoint : Server.Config.Endpoint
userEndpoint =
    "user"


getUsers : Server.Config.Context -> Cmd (WebData User)
getUsers context =
    getRequest context
        userEndpoint
        userDecoder
        |> RemoteData.sendRequest
