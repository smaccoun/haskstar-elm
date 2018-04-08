module Main exposing (..)

import Bulma.CDN exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Elements as Elements
import Bulma.Layout exposing (..)
import Form exposing (Form)
import Html exposing (Html, a, div, h1, img, main_, text)
import Html.Attributes exposing (href, src, style, target)
import RemoteData exposing (RemoteData(..), WebData)
import Server.Config as SC
import Server.RequestUtils as SR
import Views.LoginPanel as LoginPanel


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
    { context : SC.Context
    , remoteResponse : String
    , loginPage : Form () LoginPanel.LoginForm
    }


initialModel : Model
initialModel =
    { context =
        { apiBaseUrl = "http://localhost:8080" }
    , remoteResponse = ""
    , loginPage = Form.initial [] LoginPanel.validation
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch
        [ Cmd.map HandleResponse (SR.getRequestString initialModel.context "/" |> RemoteData.sendRequest)
        ]


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , initialCmds
    )



---- UPDATE ----


type Msg
    = HandleResponse (WebData String)
    | LoginPage (Form () LoginPanel.LoginForm) Form.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleResponse remoteResponse ->
            case remoteResponse of
                Success a ->
                    ( { model | remoteResponse = "SUCCESSFULLY RETRIEVED: " ++ a }, Cmd.none )

                Loading ->
                    ( { model | remoteResponse = "LOADING....." }, Cmd.none )

                Failure e ->
                    ( { model | remoteResponse = "Failed to load" }, Cmd.none )

                NotAsked ->
                    ( { model | remoteResponse = "Not Asked" }, Cmd.none )

        LoginPage formModel formMsg ->
            case formMsg of
                Form.Submit ->
                    let
                        _ =
                            Debug.log "FORM MODEL: " (Form.getOutput formModel)
                    in
                    ( model, Cmd.none )

                _ ->
                    ( { model | loginPage = Form.update LoginPanel.validation formMsg formModel }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    main_ []
        [ stylesheet
        , fluidContainer [ style [ ( "width", "300px" ) ] ] [ Elements.easyImage Elements.Natural [] "/haskstarLogo.png" ]
        , h1 [] [ text "Create Haskstar App!" ]
        , div [] [ text <| "Server Response (localhost:8080/) " ++ model.remoteResponse ]
        , a [ href "http://localhost:8080/swagger-ui", target "_blank" ] [ text "Click here to see all API endpoints (localhost:8080/swagger-ui)" ]
        , Html.map (LoginPage model.loginPage) <| LoginPanel.view model.loginPage
        ]
