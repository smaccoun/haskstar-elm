module Pages.Admin.CreateBlogPost exposing (..)

import Bulma.Columns exposing (column, columnModifiers, columns, columnsModifiers)
import Bulma.Form as BForm exposing (controlInput, controlInputModifiers, controlText, field)
import Html exposing (Html, div, input, label, text)
import Html.Events exposing (onInput)


init : BlogPost
init =
    { title = ""
    , content = ""
    }


type alias BlogPost =
    { title : String
    , content : String
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
        , viewInputField "Title" SetTitle
        , viewInputField "Content" SetContent
        ]


viewPreviewSection : BlogPost -> Html Msg
viewPreviewSection post =
    div []
        [ text post.content
        ]


viewInputField : String -> (String -> Msg) -> Html Msg
viewInputField label msgC =
    field []
        [ BForm.controlLabel [] [ text label ]
        , controlInput controlInputModifiers [] [ onInput msgC ] []
        ]
