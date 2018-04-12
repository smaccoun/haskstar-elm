module Pages.Admin.Index exposing (..)

import Html exposing (Html)
import Pages.Admin.CreateBlogPost as CreateBlogPost
import Pages.Admin.Home as Home
import Server.Config
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AdminPage
    = AdminHome
    | CreateBlogPost CreateBlogPost.BlogPost


type AdminRoute
    = AdminHomeRoute
    | CreateBlogPostRoute


type AdminPageMsg
    = HomeMsg Home.Msg
    | CreateBlogPostMsg CreateBlogPost.Msg


initializePageFromRoute : Server.Config.Context -> AdminRoute -> AdminPage
initializePageFromRoute serverContext route =
    case route of
        AdminHomeRoute ->
            AdminHome

        CreateBlogPostRoute ->
            CreateBlogPost CreateBlogPost.init


update : Server.Config.Context -> AdminPage -> AdminPageMsg -> ( AdminPage, Cmd AdminPageMsg )
update serverContext adminPage msg =
    case msg of
        HomeMsg homeMsg ->
            ( adminPage, Cmd.none )

        CreateBlogPostMsg bmsg ->
            case adminPage of
                CreateBlogPost blogPost ->
                    let
                        updatedPage =
                            CreateBlogPost.update bmsg blogPost
                    in
                    ( CreateBlogPost updatedPage, Cmd.none )

                _ ->
                    ( adminPage, Cmd.none )


viewAdminPage : Server.Config.Context -> AdminPage -> Html AdminPageMsg
viewAdminPage context adminPage =
    case adminPage of
        AdminHome ->
            Html.map HomeMsg Home.view

        CreateBlogPost blogPost ->
            Html.map CreateBlogPostMsg <| CreateBlogPost.view blogPost


routes : List (Url.Parser (AdminRoute -> a) a)
routes =
    [ Url.map AdminHomeRoute (s "admin" </> s "home")
    , Url.map CreateBlogPostRoute (s "admin" </> s "blogPost" </> s "new")
    ]
