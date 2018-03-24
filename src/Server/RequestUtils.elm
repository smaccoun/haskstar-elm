module Server.RequestUtils exposing (..)

import Http exposing (get)
import Json.Decode as Json
import Server.Config as S


getRequest : S.Context -> String -> Json.Decoder a -> Http.Request a
getRequest context url decoder =
    request context "GET" url Http.emptyBody (Http.expectJson decoder)


getRequestString : S.Context -> String -> Http.Request String
getRequestString context url =
    request context "GET" url Http.emptyBody Http.expectString


postRequest : S.Context -> String -> Http.Body -> Json.Decoder a -> Http.Request a
postRequest context url body decoder =
    request context "POST" url body (Http.expectJson decoder)


postRequestEmpty : S.Context -> String -> Http.Request String
postRequestEmpty context url =
    request context "POST" url Http.emptyBody Http.expectString


patchRequest : S.Context -> String -> Http.Body -> Json.Decoder a -> Http.Request a
patchRequest context url body decoder =
    request context "PATCH" url body (Http.expectJson decoder)


patchRequestEmptyResponse : S.Context -> String -> Http.Body -> Http.Request String
patchRequestEmptyResponse context url body =
    request context "PATCH" url body Http.expectString


deleteRequest : S.Context -> String -> Http.Request String
deleteRequest context url =
    request context "DELETE" url Http.emptyBody Http.expectString


request : S.Context -> String -> String -> Http.Body -> Http.Expect a -> Http.Request a
request context method url body expect =
    Http.request
        { method = method
        , headers = [ Http.header "Authorization" ("Bearer " ++ context.user.token) ]
        , url = url
        , body = body
        , expect = expect
        , timeout = Nothing
        , withCredentials = False
        }


getAuthHeader : S.Context -> Http.Header
getAuthHeader context =
    Http.header "Authorization" ("Bearer " ++ context.user.token)
