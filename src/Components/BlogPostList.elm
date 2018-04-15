module Components.BlogPostList exposing (..)

import Bulma.Layout exposing (centeredLevel, levelItem)
import Html exposing (Html, a, div, text)
import Link
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


view : (String -> msg) -> Model -> Html msg
view newUrlMsg remotePosts =
    case remotePosts of
        Success posts ->
            viewBlogPostList posts newUrlMsg

        Loading ->
            div [] [ text "Loading..." ]

        Failure e ->
            div [] [ text <| toString e ]

        NotAsked ->
            div [] [ text "..." ]


viewBlogPostList : List BlogPost -> (String -> msg) -> Html msg
viewBlogPostList posts newUrlMsg =
    div [] (List.map (viewBlogPostListThumb newUrlMsg) posts)


viewBlogPostListThumb : (String -> msg) -> BlogPost -> Html msg
viewBlogPostListThumb newUrlMsg blogPost =
    let
        getUrl =
            "/blogPost/" ++ blogPost.blogPostId

        titleLink =
            a [ Link.link (newUrlMsg getUrl) ] [ text blogPost.title ]
    in
    centeredLevel [] [ levelItem [] [ titleLink ] ]
