module Server.Api.UserAPI exposing (..)

import Server.Config exposing (Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams(..))
import Server.ResourceAPI exposing (..)
import Types.User exposing (User, userDecoder)


userEndpoint : Endpoint
userEndpoint =
    Endpoint "user"


getUsers : Server.Config.Context -> RemoteCmd (List User)
getUsers context =
    getContainer <| BaseRequestParams context userEndpoint userDecoder
