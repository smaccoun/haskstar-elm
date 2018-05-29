module Server.Api.BlogPostAPI exposing (..)

import Json.Decode
import Server.Config exposing (Context, Endpoint(..), apiUrl)
import Server.RequestUtils exposing (BaseRequestParams, getRequest, postRequest)
import Server.ResourceAPI exposing (RemoteCmd, createItem, getContainer, getItem, updateItem)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)
import Types.MasterEntity exposing (MasterEntity, entityDecoder)
import Types.Pagination exposing (PaginatedResult)


{- SERVER -}


blogPostEndpoint : String
blogPostEndpoint =
    "blogPost"


baseRequestParams : Context -> Json.Decode.Decoder a -> BaseRequestParams a
baseRequestParams context =
    BaseRequestParams context "blogPost"


submitPost : Context -> BlogPost -> RemoteCmd (MasterEntity BlogPost)
submitPost context post =
    createItem (baseRequestParams context blogPostDecoder) (blogPostEncoder post)


editPost : Context -> BlogPost -> String -> RemoteCmd (List String)
editPost context post uuid =
    updateItem context (Endpoint blogPostEndpoint) (blogPostEncoder post) uuid


getRequestParams : Context -> BaseRequestParams (MasterEntity BlogPost)
getRequestParams context =
    baseRequestParams context (entityDecoder blogPostDecoder)


getBlogPosts : Context -> RemoteCmd (PaginatedResult (MasterEntity BlogPost))
getBlogPosts context =
    getContainer (getRequestParams context)


getBlogPost : Context -> String -> RemoteCmd (MasterEntity BlogPost)
getBlogPost context uuid =
    getItem (getRequestParams context) uuid
