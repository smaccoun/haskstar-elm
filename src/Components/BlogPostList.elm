module Components.BlogPostList exposing (..)

import Html exposing (Html, div, text)
import RemoteData exposing (RemoteData(..), WebData)
import Server.Api.BlogPostAPI exposing (getBlogPosts)
import Server.Config exposing (Context)
import Types.BlogPost exposing (BlogPost)


-- MODEL


init : Context -> ( Model, Cmd Msg )
init context =
    ( NotAsked, Cmd.map ReceiveBlogPosts (getBlogPosts context) )


type alias Model =
    WebData (List BlogPost)



-- UPDATE


type Msg
    = ReceiveBlogPosts (WebData (List BlogPost))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveBlogPosts remotePosts ->
            remotePosts ! []



-- VIEW


view : Model -> Html msg
view remotePosts =
    case remotePosts of
        Success posts ->
            div [] (List.map viewBlogPostListThumb posts)

        Loading ->
            div [] [ text "Loading..." ]

        Failure e ->
            div [] [ text <| toString e ]

        NotAsked ->
            div [] [ text "..." ]


viewBlogPostList : List BlogPost -> Html msg
viewBlogPostList posts =
    div [] (List.map viewBlogPostListThumb posts)


viewBlogPostListThumb : BlogPost -> Html msg
viewBlogPostListThumb blogPost =
    div [] [ text blogPost.title ]
