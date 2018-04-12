module Pages.Admin.CreateBlogPost exposing (..)

import Bulma.Columns exposing (column, columnModifiers, columns, columnsModifiers)
import Bulma.Form as BForm exposing (controlInput, controlInputModifiers, controlText, controlTextArea, controlTextAreaModifiers, field)
import Html exposing (Html, div, input, label, text)
import Html.Events exposing (onInput)
import Markdown exposing (toHtml)
import Types.BlogPost exposing (BlogPost)


init : BlogPost
init =
    { title = ""
    , content = ""
    }


type Msg
    = SetTitle String
    | SetContent String


update : Msg -> BlogPost -> BlogPost
update msg post =
    case msg of
        SetTitle title ->
            { post | title = title }

        SetContent content ->
            { post | content = content }


view : BlogPost -> Html Msg
view post =
    columns columnsModifiers
        []
        [ column columnModifiers [] [ viewEditSection ]
        , column columnModifiers [] [ viewPreviewSection post ]
        ]


viewEditSection : Html Msg
viewEditSection =
    div []
        [ text "Make a blog!"
        , viewInputField "Title" asText SetTitle
        , viewInputField "Content" asTextArea SetContent
        ]


viewPreviewSection : BlogPost -> Html Msg
viewPreviewSection { title, content } =
    let
        renderTitle =
            toHtml Nothing <| "# " ++ title

        renderContent =
            toHtml Nothing content

        fullPost =
            List.concat [ renderTitle, renderContent ]
    in
    div [] fullPost


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
