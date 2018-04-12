module Pages.Admin.Home exposing (..)

import Html exposing (Html, div, h1, text)
import RemoteData exposing (RemoteData(..), WebData)
import Server.Api.Index exposing (userApiResourceParams)
import Server.Config
import Server.ResourceAPI exposing (getContainer)
import Types.User exposing (User)


init : Server.Config.Context -> ( Model, Cmd Msg )
init context =
    ( { users = NotAsked }
    , Cmd.map GetUsers <| getContainer (userApiResourceParams context)
    )


type alias Model =
    { users : WebData (List User) }


type Msg
    = GetUsers (WebData (List User))


update : Model -> Msg -> ( Model, Cmd Msg )
update model msg =
    case msg of
        GetUsers remoteUsers ->
            { model | users = remoteUsers } ! []


view : Model -> Html Msg
view model =
    div []
        [ text "Welcome admin!"
        , viewRemoteUsers model.users
        ]


viewRemoteUsers : WebData (List User) -> Html msg
viewRemoteUsers remoteUsers =
    case remoteUsers of
        Success users ->
            div [] (List.map viewUserRow users)

        _ ->
            div [] [ text "..." ]


viewUsers : List User -> Html msg
viewUsers users =
    div [] <|
        h1 [] [ text "Users" ]
            :: List.map viewUserRow users


viewUserRow : User -> Html msg
viewUserRow user =
    div [] [ text user.email ]
