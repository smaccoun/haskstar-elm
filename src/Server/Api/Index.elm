module Server.Api.Index exposing (..)

import Server.RequestUtils exposing (Endpoint(..))


userEndpoint : Endpoint
userEndpoint =
    Endpoint "user"
