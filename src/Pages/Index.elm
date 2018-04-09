module Pages.Index exposing (..)

import Components.LoginPanel as LoginPanel
import Dict exposing (Dict)
import Server.Config


type AppPage
    = Error404
    | WelcomeScreen
    | LoginPage LoginPanel.Model


urlToPageMap : Server.Config.Context -> Dict String AppPage
urlToPageMap context =
    Dict.fromList
        [ ( "/login", LoginPage (LoginPanel.init context) ) ]


urlToPage : Server.Config.Context -> String -> AppPage
urlToPage serverContext url =
    let
        _ =
            Debug.log "URL: " url
    in
    urlToPageMap serverContext
        |> Dict.get url
        |> Maybe.withDefault Error404
