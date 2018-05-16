module Components.BlogPostList exposing (..)

import Bulma.Columns exposing (..)
import Bulma.Components exposing (card, cardContent, cardHeader, cardImage, cardTitle)
import Bulma.Elements exposing (TitleSize(..), title)
import Bulma.Modifiers exposing (Width(..))
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, style)
import Link
import Markdown exposing (toHtml)
import RemoteData exposing (RemoteData(..), WebData)
import Server.Api.BlogPostAPI exposing (getBlogPosts)
import Server.Config exposing (Context)
import String.Extra
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
    let
        allThumbsView =
            column blogPostColumnModifiers
                []
                (List.map viewBlogPostListThumb posts)
    in
    div []
        [ title H3 [] [ text "Latest" ]
        , columns blogPostColumnsModifiers
            []
            [ allThumbsView ]
        ]


blogPostColumnsModifiers : ColumnsModifiers
blogPostColumnsModifiers =
    { multiline = False
    , gap = Gap0
    , display = TabletAndBeyond
    , centered = True
    }


blogPostColumnModifiers : ColumnModifiers
blogPostColumnModifiers =
    { offset = Auto
    , widths =
        { mobile = Just Width11
        , tablet = Just Width8
        , desktop = Just Width6
        , widescreen = Just Width6
        , fullHD = Just Width6
        }
    }


viewBlogPostListThumb : BlogPost -> Html Msg
viewBlogPostListThumb blogPost =
    let
        getUrl =
            "/blogPost/" ++ blogPost.blogPostId

        titleLink =
            title H4 [] [ text blogPost.title ]
    in
    a [ Link.link (NewUrl getUrl) ]
        [ card [ style [ ( "margin-top", "32px" ) ] ]
            [ cardTitle [ class "has-text-centered" ] [ titleLink ]
            , cardContent [ class "has-text-left" ]
                [ contentPreview blogPost.content ]
            ]
        ]


contentPreview : String -> Html msg
contentPreview contentMarkdown =
    let
        preview =
            List.concat
                [ contentMarkdown
                    |> String.Extra.ellipsis 200
                    |> toHtml Nothing
                , [ text "....." ]
                ]
    in
    div [] preview
