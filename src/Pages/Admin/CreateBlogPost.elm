module Pages.Admin.CreateBlogPost exposing (..)

import Html exposing (Html, div, text)
import Form

type Msg =
  FormMsg Form.Msg

view : Html Msg
view =
    div []
    [text "Make a blog!"
    ]
