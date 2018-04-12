module Server.Api.BlogPostAPI exposing (..)

import RemoteData exposing (WebData)
import Server.Config exposing (apiUrl)
import Server.RequestUtils exposing (getRequest, postRequest)
import Types.BlogPost exposing (BlogPost, blogPostDecoder)


blogPostEndpoint : Server.Config.Endpoint
blogPostEndpoint =
    "blogPost"


getBlogPosts : Server.Config.Context -> Cmd (WebData BlogPost)
getBlogPosts context =
    getRequest context
        blogPostEndpoint
        blogPostDecoder
        |> RemoteData.sendRequest
