module Views.LoginPanel exposing (..)

import Form exposing (Form)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (Html, div, input, label, text)
import Html.Events exposing (onInput)


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
        [ viewInputField "Email" form
        , viewInputField "Password" form
        ]


viewInputField : String -> Form () LoginForm -> Html Form.Msg
viewInputField labelValue form =
    let
        fieldId =
            String.toLower labelValue
    in
    div []
        [ label [] [ text labelValue ]
        , Input.textInput (Form.getFieldAsString fieldId form) []
        ]
