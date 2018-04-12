module Pages.Admin.Index exposing (..)

import Server.Config
import Pages.Admin.Home as Home
import Html exposing (Html)
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AdminPage
    = AdminHome

type AdminRoute
    = AdminHomeRoute

type AdminPageMsg =
  HomeMsg Home.Msg


initializePageFromRoute : Server.Config.Context -> AdminRoute -> AdminPage
initializePageFromRoute serverContext route =
    case route of
        AdminHomeRoute ->
            AdminHome

update : Server.Config.Context -> AdminPage -> AdminPageMsg -> (AdminPage, Cmd AdminPageMsg)
update serverContext adminPage msg =
  case msg of
    HomeMsg homeMsg ->
      (adminPage, Cmd.none)

viewAdminPage : Server.Config.Context -> AdminPage -> Html AdminPageMsg
viewAdminPage context adminPage =
  case adminPage of
    AdminHome -> Html.map HomeMsg Home.view


routes : List (Url.Parser (AdminRoute -> a) a)
routes =
        [ Url.map AdminHomeRoute (s "admin" </> s "home")
        ]
