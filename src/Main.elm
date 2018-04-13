module Main exposing (..)

import Bulma.CDN exposing (..)
import Bulma.Columns exposing (..)
import Bulma.Elements as Elements
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (Size(..))
import Components.LoginPanel as LoginPanel
import Html exposing (Html, a, div, h1, img, main_, text)
import Html.Attributes exposing (href, src, style, target)
import Link
import Navigation
import Pages.Admin.Index as AdminIndex
import Pages.Index exposing (AppPage(..), AppPageMsg(..), locationToPage)
import Pages.LoginPage as LoginPage
import RemoteData exposing (RemoteData(..), WebData)
import Server.Config as SC
import Server.RequestUtils as SR
import Task
import Types.Login exposing (LoginResponse)


---- PROGRAM ----


type alias Flags =
    { environment : String
    , apiBaseUrl : String
    }


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



---- MODEL ----


type alias Model =
    { context : SC.Context
    , remoteResponse : String
    , currentPage : AppPage
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        { apiBaseUrl } =
            flags

        initialContext =
            { apiBaseUrl = apiBaseUrl, jwtToken = Nothing }

        ( initPage, initPageCmd ) =
            locationToPage initialContext location

        model =
            { context = initialContext
            , remoteResponse = ""
            , currentPage = initPage
            }

        initialCmds =
            Cmd.batch
                [ Cmd.map HandleResponse (SR.getRequestString model.context "" |> RemoteData.sendRequest)
                , Cmd.map PageMsgW initPageCmd
                ]
    in
    ( model
    , initialCmds
    )



---- UPDATE ----


type Msg
    = UrlChange Navigation.Location
    | NewUrl String
    | HandleResponse (WebData String)
    | PageMsgW AppPageMsg
    | ReceiveLogin (WebData LoginResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                ( newPage, newPageCmd ) =
                    locationToPage model.context location
            in
            ( { model | currentPage = newPage }, Cmd.map PageMsgW newPageCmd )

        NewUrl destination ->
            let
                ( newUrlModel, cMsg ) =
                    Link.navigate model destination
            in
            ( newUrlModel, cMsg )

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
                Success { jwtToken } ->
                    let
                        curContext =
                            model.context

                        newContext =
                            { curContext | jwtToken = Just jwtToken }
                    in
                    ( { model | context = newContext }
                    , Task.perform (always (NewUrl "/admin/home")) (Task.succeed ())
                    )

                _ ->
                    ( model, Cmd.none )

        PageMsgW pageMsg ->
            let
                ( page, pageCmd ) =
                    Pages.Index.update pageMsg model.currentPage

                extraPageCmd =
                    case pageMsg of
                        LoginPageMsg (LoginPanel.ReceiveLogin jwtToken) ->
                            Task.perform (always (ReceiveLogin jwtToken)) (Task.succeed ())

                        _ ->
                            Cmd.none
            in
            { model | currentPage = page }
                ! [ Cmd.map PageMsgW pageCmd
                  , extraPageCmd
                  ]



---- VIEW ----


view : Model -> Html Msg
view model =
    main_ []
        [ stylesheet
        , case model.currentPage of
            Error404 ->
                div [] [ text "Error 404: Invalid URL" ]

            WelcomeScreen ->
                viewWelcomeScreen model

            LoginPage loginPageModel ->
                LoginPage.view (\m -> PageMsgW (LoginPageMsg m)) loginPageModel

            AdminPageW adminPage ->
                AdminIndex.viewAdminPage model.context adminPage
                    |> Html.map (\m -> PageMsgW (AdminPageMsg m))
        ]


viewWelcomeScreen : Model -> Html Msg
viewWelcomeScreen model =
    div []
        [ hero { heroModifiers | size = Small, color = Bulma.Modifiers.Light }
            []
            [ heroBody []
                [ fluidContainer [ style [ ( "display", "flex" ), ( "justify-content", "center" ) ] ]
                    [ Elements.easyImage Elements.Natural [ style [ ( "width", "300px" ) ] ] "/haskstarLogo.png"
                    ]
                ]
            ]
        , h1 [] [ text "Create Haskstar App!" ]
        , section NotSpaced
            []
            [ Elements.title Elements.H2 [] [ text "Server Connection" ]
            , div [] [ text <| "Server Response (localhost:8080/) " ++ model.remoteResponse ]
            , a [ href "http://localhost:8080/swagger-ui", target "_blank" ] [ text "Click here to see all API endpoints (localhost:8080/swagger-ui)" ]
            ]
        , a [ Link.link (NewUrl "login") ] [ text "Go to login page" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
