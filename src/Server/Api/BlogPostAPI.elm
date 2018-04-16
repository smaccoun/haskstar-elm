module Server.Api.BlogPostAPI exposing (..)

import Server.Config exposing (Context, Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams(..), getRequest, postRequest)
import Server.ResourceAPI exposing (RemoteCmd, createItem, getContainer, getItem)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)


blogPostEndpoint : Endpoint
blogPostEndpoint =
    Endpoint "blogPost"



{- SERVER -}


baseRequestParams : Context -> BaseRequestParams BlogPost
baseRequestParams context =
    BaseRequestParams context blogPostEndpoint blogPostDecoder


submitPost : Context -> BlogPost -> RemoteCmd BlogPost
submitPost context post =
    createItem (baseRequestParams context) (blogPostEncoder post)


getBlogPosts : Context -> RemoteCmd (List BlogPost)
getBlogPosts context =
    getContainer (baseRequestParams context)


getBlogPost : Context -> String -> RemoteCmd BlogPost
getBlogPost context uuid =
    getItem (baseRequestParams context) uuid
