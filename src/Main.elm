module Main exposing (..)

import Bulma.CDN exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Elements as Elements
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (Size(..))
import Components.LoginPanel as LoginPanel
import Form exposing (Form)
import Html exposing (Html, a, div, h1, img, main_, text)
import Html.Attributes exposing (href, src, style, target)
import Pages.Index exposing (AppPage(..))
import RemoteData exposing (RemoteData(..), WebData)
import Server.Api.AuthAPI exposing (performLogin)
import Server.Config as SC
import Server.RequestUtils as SR
import Task


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
    , currentPage : AppPage
    }


initialModel : Model
initialModel =
    let
        initialContext =
            { apiBaseUrl = "http://localhost:8080", jwtToken = Nothing }
    in
    { context = initialContext
    , remoteResponse = ""
    , currentPage = LoginPage (LoginPanel.init initialContext)
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch
        [ Cmd.map HandleResponse (SR.getRequestString initialModel.context "" |> RemoteData.sendRequest)
        ]


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , initialCmds
    )



---- UPDATE ----


type Msg
    = HandleResponse (WebData String)
    | PageMsgW PageMsg
    | ReceiveLogin (WebData String)


type PageMsg
    = LoginPageMsg LoginPanel.Msg


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

        ReceiveLogin loginResponse ->
            case loginResponse of
                Success jwtToken ->
                    let
                        curContext =
                            model.context

                        newContext =
                            { curContext | jwtToken = Just jwtToken }
                    in
                    ( { model | context = newContext }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        PageMsgW pageMsg ->
            case pageMsg of
                LoginPageMsg loginPageMsg ->
                    case model.currentPage of
                        LoginPage loginPageModel ->
                            let
                                ( uLoginModel, cmd ) =
                                    LoginPanel.update loginPageMsg loginPageModel
                            in
                            ( { model | currentPage = LoginPage uLoginModel }
                            , Cmd.batch
                                [ Cmd.map (\w -> PageMsgW (LoginPageMsg w)) cmd
                                , case loginPageMsg of
                                    LoginPanel.ReceiveLogin remoteLogin ->
                                        Task.perform (always (ReceiveLogin remoteLogin)) (Task.succeed ())

                                    _ ->
                                        Cmd.none
                                ]
                            )



---- VIEW ----


view : Model -> Html Msg
view model =
    main_ []
        [ stylesheet
        , hero { heroModifiers | size = Small, color = Bulma.Modifiers.Light }
            []
            [ heroBody []
                [ fluidContainer [ style [ ( "width", "300px" ) ] ] [ Elements.easyImage Elements.Natural [] "/haskstarLogo.png" ]
                ]
            ]
        , h1 [] [ text "Create Haskstar App!" ]
        , section NotSpaced
            []
            [ Elements.title Elements.H2 [] [ text "Server Connection" ]
            , div [] [ text <| "Server Response (localhost:8080/) " ++ model.remoteResponse ]
            , a [ href "http://localhost:8080/swagger-ui", target "_blank" ] [ text "Click here to see all API endpoints (localhost:8080/swagger-ui)" ]
            ]
        , section NotSpaced
            []
            [ div [] [ text "You can login to an admin account by using username 'admin@haskstar.com' and password 'haskman'" ]
            , case model.currentPage of
                LoginPage loginPageModel ->
                    Html.map (\m -> PageMsgW (LoginPageMsg m)) <| LoginPanel.view loginPageModel
            ]
        ]
