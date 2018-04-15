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
    | NewUrl String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl destination ->
            let
                ( newUrlModel, cMsg ) =
                    Link.navigate model destination
            in
            ( newUrlModel, cMsg )

        ReceiveBlogPosts remotePosts ->
            remotePosts ! []



-- VIEW


view : Model -> Html Msg
view remotePosts =
    case remotePosts of
        Success posts ->
            viewBlogPostList posts

        Loading ->
            div [] [ text "Loading..." ]

        Failure e ->
            div [] [ text <| toString e ]

        NotAsked ->
            div [] [ text "..." ]


viewBlogPostList : List BlogPost -> Html Msg
viewBlogPostList posts =
    div [] (List.map viewBlogPostListThumb posts)


viewBlogPostListThumb : BlogPost -> Html Msg
viewBlogPostListThumb blogPost =
    let
        getUrl =
            "/blogPost/" ++ blogPost.blogPostId

        titleLink =
            a [ Link.link (NewUrl getUrl) ] [ text blogPost.title ]
    in
    centeredLevel [] [ levelItem [] [ titleLink ] ]
