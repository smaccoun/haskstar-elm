module Pages.Admin.Index exposing (..)

import Server.Config
import Pages.Admin.Home as Home
import Pages.Admin.CreateBlogPost as CreateBlogPost
import Html exposing (Html)
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AdminPage
    = AdminHome
    | CreateBlogPost

type AdminRoute
    = AdminHomeRoute
    | CreateBlogPostRoute

type AdminPageMsg =
  HomeMsg Home.Msg
  | CreateBlogPostMsg CreateBlogPost.Msg


initializePageFromRoute : Server.Config.Context -> AdminRoute -> AdminPage
initializePageFromRoute serverContext route =
    case route of
        AdminHomeRoute ->
            AdminHome
        CreateBlogPostRoute ->
            CreateBlogPost

update : Server.Config.Context -> AdminPage -> AdminPageMsg -> (AdminPage, Cmd AdminPageMsg)
update serverContext adminPage msg =
  case msg of
    HomeMsg homeMsg ->
      (adminPage, Cmd.none)
    CreateBlogPostMsg bmsg ->
      (adminPage, Cmd.none)

viewAdminPage : Server.Config.Context -> AdminPage -> Html AdminPageMsg
viewAdminPage context adminPage =
  case adminPage of
    AdminHome -> Html.map HomeMsg Home.view
    CreateBlogPost -> Html.map CreateBlogPostMsg CreateBlogPost.view


routes : List (Url.Parser (AdminRoute -> a) a)
routes =
        [ Url.map AdminHomeRoute (s "admin" </> s "home")
        , Url.map CreateBlogPostRoute (s "admin" </> s "blogPost" </> s "new")
        ]
