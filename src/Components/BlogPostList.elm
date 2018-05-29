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
import Types.BlogPost exposing (BlogPostE)
import Types.Pagination exposing (PaginatedResult)


-- MODEL


init : Context -> ( Model, Cmd Msg )
init context =
    ( NotAsked, Cmd.map ReceiveBlogPostEs (getBlogPosts context) )


type alias Model =
    WebData (PaginatedResult BlogPostE)



-- UPDATE


type Msg
    = ReceiveBlogPostEs (WebData (PaginatedResult BlogPostE))
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

        ReceiveBlogPostEs remotePosts ->
            remotePosts ! []



-- VIEW


view : Model -> Html Msg
view remotePosts =
    case remotePosts of
        Success posts ->
            viewBlogPostEList posts.data

        Loading ->
            div [] [ text "Loading..." ]

        Failure e ->
            div [] [ text <| toString e ]

        NotAsked ->
            div [] [ text "..." ]


viewBlogPostEList : List BlogPostE -> Html Msg
viewBlogPostEList posts =
    let
        allThumbsView =
            List.map viewBlogPostEListThumb posts
    in
    div [ style [ ( "padding", "32px" ) ] ]
        [ columns blogPostColumnsModifiers
            []
            [ column blogPostColumnModifiers
                []
                [ title H3 [ class "has-text-left" ] [ text "Latest" ]
                , div [] allThumbsView
                ]
            ]
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


viewBlogPostEListThumb : BlogPostE -> Html Msg
viewBlogPostEListThumb { meta, baseEntity } =
    let
        getUrl =
            "/blogPost/" ++ meta.appId

        titleLink =
            title H4 [] [ text baseEntity.title ]
    in
    a [ Link.link (NewUrl getUrl) ]
        [ card [ style [ ( "margin-top", "32px" ) ] ]
            [ cardTitle [ class "has-text-centered" ] [ titleLink ]
            , cardContent [ class "has-text-left" ]
                [ contentPreview baseEntity.content ]
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
