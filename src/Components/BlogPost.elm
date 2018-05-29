module Components.BlogPost exposing (..)

import Html exposing (Html, a, div, text)
import RemoteData exposing (RemoteData(..), WebData)
import Server.Api.BlogPostAPI exposing (getBlogPost)
import Server.Config exposing (Context)
import Types.BlogPost exposing (BlogPost, BlogPostE)
import Views.BlogPost exposing (viewBlogPost)


-- MODEL


init : Context -> String -> ( Model, Cmd Msg )
init context uuid =
    ( NotAsked, Cmd.map ReceiveBlogPost (getBlogPost context uuid) )


type alias Model =
    WebData BlogPostE



-- UPDATE


type Msg
    = ReceiveBlogPost (WebData BlogPostE)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveBlogPost remotePosts ->
            remotePosts ! []



-- VIEW


view : Model -> Html Msg
view remotePost =
    case remotePost of
        Success post ->
            viewBlogPost post.baseEntity

        Loading ->
            div [] [ text "Loading..." ]

        Failure e ->
            div [] [ text <| toString e ]

        NotAsked ->
            div [] [ text "..." ]
