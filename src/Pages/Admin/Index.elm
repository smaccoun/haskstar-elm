module Pages.Admin.Index exposing (..)

import Html exposing (Html)
import Pages.Admin.CreateBlogPost as CreateBlogPost
import Pages.Admin.Home as Home
import Server.Config
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AdminPage
    = AdminHome Home.Model
    | CreateBlogPost CreateBlogPost.Model


type AdminRoute
    = AdminHomeRoute
    | CreateBlogPostRoute


type AdminPageMsg
    = HomeMsg Home.Msg
    | CreateBlogPostMsg CreateBlogPost.Msg


initializePageFromRoute : Server.Config.Context -> AdminRoute -> ( AdminPage, Cmd AdminPageMsg )
initializePageFromRoute serverContext route =
    case route of
        AdminHomeRoute ->
            let
                ( initialPage, initialCmd ) =
                    Home.init serverContext
            in
            ( AdminHome initialPage, Cmd.map HomeMsg initialCmd )

        CreateBlogPostRoute ->
            CreateBlogPost (CreateBlogPost.init serverContext) ! []


update : AdminPage -> AdminPageMsg -> ( AdminPage, Cmd AdminPageMsg )
update adminPage msg =
    case msg of
        HomeMsg homeMsg ->
            case adminPage of
                AdminHome homeModel ->
                    let
                        ( updatedPage, pageCmd ) =
                            Home.update homeModel homeMsg
                    in
                    ( AdminHome updatedPage, Cmd.map HomeMsg pageCmd )

                _ ->
                    ( adminPage, Cmd.none )

        CreateBlogPostMsg bmsg ->
            case adminPage of
                CreateBlogPost blogPost ->
                    let
                        ( updatedPage, pageCmd ) =
                            CreateBlogPost.update bmsg blogPost
                    in
                    ( CreateBlogPost updatedPage, Cmd.map CreateBlogPostMsg pageCmd )

                _ ->
                    ( adminPage, Cmd.none )


viewAdminPage : AdminPage -> Html AdminPageMsg
viewAdminPage adminPage =
    case adminPage of
        AdminHome homeModel ->
            Html.map HomeMsg <| Home.view homeModel

        CreateBlogPost blogPost ->
            Html.map CreateBlogPostMsg <| CreateBlogPost.view blogPost


routes : List (Url.Parser (AdminRoute -> a) a)
routes =
    [ Url.map AdminHomeRoute (s "admin" </> s "home")
    , Url.map CreateBlogPostRoute (s "admin" </> s "blogPost" </> s "new")
    ]
