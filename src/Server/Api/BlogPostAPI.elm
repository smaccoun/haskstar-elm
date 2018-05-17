module Server.Api.BlogPostAPI exposing (..)

import Server.Config exposing (Context, Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams(..), getRequest, postRequest)
import Server.ResourceAPI exposing (RemoteCmd, createItem, getContainer, getItem)
import Types.BlogPost exposing (BlogPost, BlogPostNew, blogPostDecoder, blogPostEncoder, blogPostNewDecoder)


blogPostEndpoint : Endpoint
blogPostEndpoint =
    Endpoint "blogPost"



{- SERVER -}


baseRequestParams : Context -> BaseRequestParams BlogPost
baseRequestParams context =
    BaseRequestParams context blogPostEndpoint blogPostDecoder


submitPost : Context -> BlogPostNew -> RemoteCmd BlogPostNew
submitPost context post =
    let
        params =
            BaseRequestParams context blogPostEndpoint blogPostNewDecoder
    in
    createItem params (blogPostEncoder post)


getBlogPosts : Context -> RemoteCmd (List BlogPost)
getBlogPosts context =
    getContainer (baseRequestParams context)


getBlogPost : Context -> String -> RemoteCmd BlogPost
getBlogPost context uuid =
    getItem (baseRequestParams context) uuid
