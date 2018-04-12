module Server.Api.Index exposing (..)

import Server.Config exposing (Context)
import Server.RequestUtils exposing (BaseRequestParams(..), Endpoint(..))
import Types.User exposing (User, userDecoder)


userEndpoint : Endpoint
userEndpoint =
    Endpoint "users"


userApiResourceParams : Context -> BaseRequestParams User
userApiResourceParams context =
    BaseRequestParams context userEndpoint userDecoder
