module Pages.Admin.Index exposing (..)

import Server.Config
import Pages.Admin.Home as Home
import Html exposing (Html)


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
