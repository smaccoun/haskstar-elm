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
import Types.BlogPost exposing (BlogPost, BlogPostE, blogPostDecoder, blogPostEncoder)
import Types.MasterEntity exposing (MasterEntity)
import Views.BlogPost exposing (viewBlogPost)


initNewPost : BlogPost
initNewPost =
    { title = ""
    , content = ""
    }


type ViewState
    = Initializing (WebData BlogPostE)
    | Editing Blog
    | Submitting


type Blog
    = New BlogPost
    | Existing BlogPostE


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
    | ReceiveBlog (WebData BlogPostE)
    | ReceiveSubmittedBlog (WebData (MasterEntity BlogPost))
    | ReceiveEditedBlog (WebData (List String))
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
                                    let
                                        oldSub =
                                            bp.baseEntity

                                        newSub =
                                            { oldSub | title = title }
                                    in
                                    Existing { bp | baseEntity = newSub }
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
                                    let
                                        oldSub =
                                            bp.baseEntity

                                        newSub =
                                            { oldSub | content = content }
                                    in
                                    Existing { bp | baseEntity = newSub }
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

                                Existing { meta, baseEntity } ->
                                    let
                                        { updatedAt, appId, createdAt } =
                                            meta

                                        { title, content } =
                                            baseEntity

                                        ( uuid, bpBase ) =
                                            ( appId, { title = title, content = content } )
                                    in
                                    Cmd.map ReceiveEditedBlog <| editPost model.context bpBase uuid

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

        ReceiveEditedBlog result ->
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

                            Existing { baseEntity } ->
                                { title = baseEntity.title, content = baseEntity.content }
                in
                [ column columnModifiers [] [ viewEditSection post ]
                , column columnModifiers [] [ viewBlogPost Nothing post ]
                ]

            Submitting ->
                [ text "............." ]
        )


viewEditSection : BlogPost -> Html Msg
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
