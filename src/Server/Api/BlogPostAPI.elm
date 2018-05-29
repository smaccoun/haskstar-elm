module Server.Api.BlogPostAPI exposing (..)

import Server.Config exposing (Context, Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams(..), getRequest, postRequest)
import Server.ResourceAPI exposing (RemoteCmd, createItem, getContainer, getItem, updateItem)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)
import Types.MasterEntity exposing (MasterEntity, entityDecoder)
import Types.Pagination exposing (PaginatedResult)


blogPostEndpoint : Endpoint
blogPostEndpoint =
    Endpoint "blogPost"



{- SERVER -}


baseRequestParams context =
    BaseRequestParams context blogPostEndpoint


submitPost : Context -> BlogPost -> RemoteCmd BlogPost
submitPost context post =
    createItem (baseRequestParams context blogPostDecoder) (blogPostEncoder post)


editPost : Context -> BlogPost -> String -> RemoteCmd String
editPost context post uuid =
    updateItem (baseRequestParams context blogPostDecoder) (blogPostEncoder post) uuid


getRequestParams : Context -> BaseRequestParams (MasterEntity BlogPost)
getRequestParams context =
    baseRequestParams context (entityDecoder blogPostDecoder)


getBlogPosts : Context -> RemoteCmd (PaginatedResult (MasterEntity BlogPost))
getBlogPosts context =
    getContainer (getRequestParams context)


getBlogPost : Context -> String -> RemoteCmd (MasterEntity BlogPost)
getBlogPost context uuid =
    getItem (getRequestParams context) uuid
