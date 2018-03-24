module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)

import Server.Config as S


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }

---- MODEL ----

type alias Model =
    {context : S.Context}

initialModel : Model
initialModel =
    {context =
       {apiBaseUrl = "localhost:8080"}
    }

init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )


---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Create Haskstar App!" ]
        ]




