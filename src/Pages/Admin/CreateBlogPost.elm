module Pages.Admin.CreateBlogPost exposing (..)

import Bulma.Columns exposing (column, columnModifiers, columns, columnsModifiers)
import Bulma.Elements exposing (button, buttonModifiers)
import Bulma.Form as BForm exposing (controlInput, controlInputModifiers, controlText, controlTextArea, controlTextAreaModifiers, field)
import Bulma.Modifiers exposing (Color(..))
import Html exposing (Html, div, input, label, text)
import Html.Events exposing (onClick, onInput)
import RemoteData exposing (WebData)
import Server.Api.BlogPostAPI exposing (submitPost)
import Server.Config exposing (Context)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)
import Views.BlogPost exposing (viewBlogPost)


initPost : BlogPost
initPost =
    { blogPostId = ""
    , title = ""
    , content = ""
    }


init : Context -> Model
init context =
    { post = initPost
    , context = context
    }


type alias Model =
    { context : Context
    , post : BlogPost
    }


type Msg
    = SetTitle String
    | SetContent String
    | ReceiveSubmittedBlog (WebData BlogPost)
    | SubmitBlog


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTitle title ->
            let
                curPost =
                    model.post

                updatedPost =
                    { curPost | title = title }
            in
            { model | post = updatedPost } ! []

        SetContent content ->
            let
                curPost =
                    model.post

                updatedPost =
                    { curPost | content = content }
            in
            { model | post = updatedPost } ! []

        SubmitBlog ->
            model
                ! [ Cmd.map ReceiveSubmittedBlog <| submitPost model.context model.post ]

        ReceiveSubmittedBlog result ->
            model ! []


view : Model -> Html Msg
view model =
    columns columnsModifiers
        []
        [ column columnModifiers [] [ viewEditSection model ]
        , column columnModifiers [] [ viewBlogPost model.post ]
        ]


viewEditSection : Model -> Html Msg
viewEditSection model =
    div []
        [ viewInputField "Title" asText SetTitle
        , viewInputField "Content" asTextArea SetContent
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


viewInputField : String -> InputType Msg -> (String -> Msg) -> Html Msg
viewInputField label asInputType msgC =
    field []
        [ BForm.controlLabel [] [ text label ]
        , asInputType [] [ onInput msgC ] []
        ]
