module Server.Api.BlogPostAPI exposing (..)

import Server.Config exposing (Context, Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams(..), getRequest, postRequest)
import Server.ResourceAPI exposing (RemoteCmd, createItem, getContainer, getItem, updateItem)
import Types.BlogPost exposing (BlogPost, BlogPostNew, blogPostDecoder, blogPostEncoder, blogPostNewDecoder)
import Types.Pagination exposing (PaginatedResult)


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


editPost : Context -> BlogPostNew -> String -> RemoteCmd BlogPostNew
editPost context post uuid =
    let
        params =
            BaseRequestParams context blogPostEndpoint blogPostNewDecoder
    in
    updateItem params (blogPostEncoder post) uuid


getBlogPosts : Context -> RemoteCmd (PaginatedResult BlogPost)
getBlogPosts context =
    getContainer (baseRequestParams context)


getBlogPost : Context -> String -> RemoteCmd BlogPost
getBlogPost context uuid =
    getItem (baseRequestParams context) uuid
