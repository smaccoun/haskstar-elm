module Pages.Index exposing (..)

import Components.LoginPanel as LoginPanel
import Navigation exposing (Location)
import Server.Config
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AppPage
    = Error404
    | WelcomeScreen
    | LoginPage LoginPanel.Model


type Route
    = Welcome
    | Login


initializePageFromRoute : Server.Config.Context -> Route -> AppPage
initializePageFromRoute serverContext route =
    case route of
        Welcome ->
            WelcomeScreen

        Login ->
            LoginPage (LoginPanel.init serverContext)


locationToPage : Server.Config.Context -> Location -> AppPage
locationToPage serverContext location =
    Url.parsePath routes location
        |> Maybe.map (initializePageFromRoute serverContext)
        |> Maybe.withDefault Error404


routes : Url.Parser (Route -> a) a
routes =
    Url.oneOf
        [ Url.map Welcome top
        , Url.map Login (s "login")
        ]
