module Views.LoginPanel exposing (..)

import Form exposing (Form)
import Form.Input as Input exposing (Input)
import Form.Validate as Validate exposing (..)
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


type alias LoginForm =
    { email : String
    , password : String
    }


validation : Validation () LoginForm
validation =
    map2 LoginForm
        (field "email" email)
        (field "password" string)


view : Form () LoginForm -> Html Form.Msg
view form =
    div []
        [ viewInputField "Email" Input.textInput form
        , viewInputField "Password" Input.passwordInput form
        , button
            [ onClick Form.Submit ]
            [ text "Submit" ]
        ]


viewInputField : String -> Input () String -> Form () LoginForm -> Html Form.Msg
viewInputField labelValue inputType form =
    let
        fieldId =
            String.toLower labelValue

        fieldValue =
            Form.getFieldAsString fieldId form
    in
    div []
        [ label [] [ text labelValue ]
        , inputType (Form.getFieldAsString fieldId form) []
        , errorFor fieldValue
        ]


errorFor field =
    case Debug.log "ERROR: " field.liveError of
        Just error ->
            -- replace toString with your own translations
            div [ style [ ( "color", "red" ) ] ] [ text (toString error) ]

        Nothing ->
            text ""
