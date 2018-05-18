module Pages.Admin.CreateBlogPost exposing (..)

import Bulma.Columns exposing (column, columnModifiers, columns, columnsModifiers)
import Bulma.Elements exposing (button, buttonModifiers)
import Bulma.Form as BForm exposing (controlInput, controlInputModifiers, controlText, controlTextArea, controlTextAreaModifiers, field)
import Bulma.Modifiers exposing (Color(..))
import Html exposing (Html, div, input, label, text)
import Html.Events exposing (onClick, onInput)
import Link
import RemoteData exposing (WebData)
import Server.Api.BlogPostAPI exposing (editPost, getBlogPost, submitPost)
import Server.Config exposing (Context)
import Types.BlogPost exposing (BlogPost, BlogPostNew, blogPostDecoder, blogPostEncoder)
import Views.BlogPost exposing (viewBlogPost)


initNewPost : BlogPostNew
initNewPost =
    { title = ""
    , content = ""
    }


type ViewState
    = Initializing (WebData BlogPost)
    | Editing Blog
    | Submitting


type Blog
    = New BlogPostNew
    | Existing BlogPost


type alias Model =
    { context : Context
    , viewState : ViewState
    }


init : Context -> Maybe String -> ( Model, Cmd Msg )
init context mbId =
    ( { viewState =
            case mbId of
                Nothing ->
                    Editing <| New initNewPost

                Just id ->
                    Initializing RemoteData.NotAsked
      , context = context
      }
    , case mbId of
        Nothing ->
            Cmd.none

        Just id ->
            Cmd.map ReceiveBlog <| getBlogPost context id
    )


type Msg
    = SetTitle String
    | SetContent String
    | ReceiveBlog (WebData BlogPost)
    | ReceiveSubmittedBlog (WebData BlogPostNew)
    | SubmitBlog


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTitle title ->
            case model.viewState of
                Editing blogPost ->
                    let
                        post =
                            case blogPost of
                                New bp ->
                                    New { bp | title = title }

                                Existing bp ->
                                    Existing { bp | title = title }
                    in
                    { model | viewState = Editing post } ! []

                _ ->
                    Debug.crash "Impossible state"

        SetContent content ->
            case model.viewState of
                Editing blogPost ->
                    let
                        post =
                            case blogPost of
                                New bp ->
                                    New { bp | content = content }

                                Existing bp ->
                                    Existing { bp | content = content }
                    in
                    { model | viewState = Editing post } ! []

                _ ->
                    Debug.crash "Impossible state"

        SubmitBlog ->
            model
                ! [ case model.viewState of
                        Editing bp ->
                            case bp of
                                New bpNew ->
                                    Cmd.map ReceiveSubmittedBlog <| submitPost model.context bpNew

                                Existing { blogPostId, title, content } ->
                                    let
                                        ( uuid, bpBase ) =
                                            ( blogPostId, { title = title, content = content } )
                                    in
                                    Cmd.map ReceiveSubmittedBlog <| editPost model.context bpBase uuid

                        _ ->
                            Debug.crash "Impossible state"
                  ]

        ReceiveBlog result ->
            case result of
                RemoteData.Success r ->
                    { model | viewState = Editing (Existing r) } ! []

                RemoteData.Failure e ->
                    Debug.crash "FAILED TO SUBMIT POST! "

                _ ->
                    { model | viewState = Initializing result } ! []

        ReceiveSubmittedBlog result ->
            case result of
                RemoteData.Success r ->
                    let
                        destination =
                            "/blogPost"
                    in
                    Link.navigate model destination

                RemoteData.Failure e ->
                    Debug.crash "FAILED TO SUBMIT POST! "

                _ ->
                    model ! []


view : Model -> Html Msg
view model =
    columns columnsModifiers
        []
        (case model.viewState of
            Initializing _ ->
                [ text "Loading..." ]

            Editing blogType ->
                let
                    post =
                        case blogType of
                            New bpNew ->
                                bpNew

                            Existing bp ->
                                { title = bp.title, content = bp.content }
                in
                [ column columnModifiers [] [ viewEditSection post ]
                , column columnModifiers [] [ viewBlogPost post ]
                ]

            Submitting ->
                [ text "............." ]
        )


viewEditSection : BlogPostNew -> Html Msg
viewEditSection { title, content } =
    div []
        [ viewInputField "Title" title asText SetTitle
        , viewInputField "Content" content asTextArea SetContent
        , button { buttonModifiers | color = Primary }
            [ onClick SubmitBlog ]
            [ text "Submit" ]
        ]


type alias InputType msg =
    List (Html.Attribute msg)
    -> List (Html.Attribute msg)
    -> List (Html msg)
    -> BForm.Control msg


asText : InputType Msg
asText =
    controlInput controlInputModifiers


asTextArea : InputType Msg
asTextArea =
    controlTextArea controlTextAreaModifiers


viewInputField : String -> String -> InputType Msg -> (String -> Msg) -> Html Msg
viewInputField label curVal asInputType msgC =
    field []
        [ BForm.controlLabel [] [ text label ]
        , asInputType [] [ onInput msgC ] [ text curVal ]
        ]
