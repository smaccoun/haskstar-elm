module Server.Api.Index exposing (..)

import Server.Config exposing (Context, Endpoint(..))
import Server.RequestUtils exposing (BaseRequestParams)
import Types.User exposing (User, userDecoder)


userApiResourceParams : Context -> BaseRequestParams User
userApiResourceParams context =
    BaseRequestParams context "users" userDecoder


loginEndpoint : Endpoint
loginEndpoint =
    Endpoint "login"


blogPostEndpoint : Endpoint
blogPostEndpoint =
    Endpoint "blogPost"
