module Pages.Admin.Home exposing (..)

import Html exposing (Html, div, text)
import RemoteData exposing (WebData)
import Types.User exposing (User)


type alias Model = {users: WebData (List User)}
type Msg =
  GetUsers (WebData (List User))

view : Html Msg
view =
    div [] [ text "Welcome admin!" ]
