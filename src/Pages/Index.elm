module Pages.Index exposing (..)

import Components.BlogPostList as BPL
import Components.LoginPanel as LoginPanel
import Navigation exposing (Location)
import Pages.Admin.Index as Admin exposing (AdminRoute(..))
import Server.Config
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AppPage
    = Error404
    | WelcomeScreen
    | LoginPage LoginPanel.Model
    | AdminPageW Admin.AdminPage
    | BlogPostList BPL.Model


type AppPageMsg
    = LoginPageMsg LoginPanel.Msg
    | AdminPageMsg Admin.AdminPageMsg
    | BlogPostListMsg BPL.Msg


type Route
    = Welcome
    | Login
    | AdminRouteW AdminRoute
    | BlogPostRoute CrudRoute


initializePageFromRoute : Server.Config.Context -> Route -> ( AppPage, Cmd AppPageMsg )
initializePageFromRoute serverContext route =
    case route of
        Welcome ->
            ( WelcomeScreen, Cmd.none )

        Login ->
            ( LoginPage (LoginPanel.init serverContext), Cmd.none )

        AdminRouteW adminRoute ->
            let
                ( adminPage, adminPageCmd ) =
                    Admin.initializePageFromRoute serverContext adminRoute
            in
            ( AdminPageW adminPage, Cmd.map AdminPageMsg adminPageCmd )

        BlogPostRoute crud ->
            let
                ( bpModel, bpCmd ) =
                    BPL.init serverContext
            in
            ( BlogPostList bpModel, Cmd.map BlogPostListMsg bpCmd )


locationToPage : Server.Config.Context -> Location -> ( AppPage, Cmd AppPageMsg )
locationToPage serverContext location =
    Url.parsePath routes location
        |> Maybe.map (initializePageFromRoute serverContext)
        |> Maybe.withDefault ( Error404, Cmd.none )


routes : Url.Parser (Route -> Route) Route
routes =
    let
        unprotected =
            [ Url.map Welcome top
            , Url.map Login (s "login")
            , Url.map (AdminRouteW Admin.AdminHomeRoute) (s "admin" </> s "home")
            ]

        resources =
            [ makeDefaultResourceRoutes [ "blogPost" ] BlogPostRoute ]
                |> List.concatMap identity

        adminRoutes =
            List.map (Url.map AdminRouteW) Admin.routes
    in
    Url.oneOf <| List.concatMap identity [ unprotected, resources, adminRoutes ]


update : AppPageMsg -> AppPage -> ( AppPage, Cmd AppPageMsg )
update pageMsg currentPage =
    case pageMsg of
        LoginPageMsg loginPageMsg ->
            case currentPage of
                LoginPage loginPageModel ->
                    let
                        ( uLoginModel, cmd ) =
                            LoginPanel.update loginPageMsg loginPageModel
                    in
                    ( LoginPage uLoginModel, Cmd.map LoginPageMsg cmd )

                _ ->
                    ( currentPage, Cmd.none )

        AdminPageMsg adminPageMsg ->
            case currentPage of
                AdminPageW adminPage ->
                    let
                        ( updatedAdminPage, adminPageCmd ) =
                            Admin.update adminPage adminPageMsg
                    in
                    ( AdminPageW updatedAdminPage
                    , Cmd.map AdminPageMsg adminPageCmd
                    )

                _ ->
                    ( currentPage, Cmd.none )

        BlogPostListMsg bpMsg ->
            case currentPage of
                BlogPostList bplModel ->
                    let
                        ( updatedBPLModel, bplCmd ) =
                            BPL.update bpMsg bplModel
                    in
                    ( BlogPostList updatedBPLModel, Cmd.map BlogPostListMsg bplCmd )

                _ ->
                    ( currentPage, Cmd.none )



{- CRUD Resource Helpers -}


type CrudRoute
    = Index
    | Show Int
    | Edit Int
    | New


type alias BaseParser a =
    Url.Parser (Route -> a) a


makeDefaultResourceRoutes : List String -> (CrudRoute -> Route) -> List (BaseParser Route)
makeDefaultResourceRoutes urlList crudRoute =
    let
        baseUrl =
            arrayToBaseUrl urlList
    in
    [ Url.map (\u -> crudRoute (Show u)) (baseUrl </> Url.int)
    , Url.map (\u -> crudRoute (Edit u)) (baseUrl </> Url.int </> Url.s "edit")
    , Url.map (crudRoute Index) baseUrl
    , Url.map (crudRoute New) (baseUrl </> Url.s "new")
    ]


arrayToBaseUrl : List String -> Url.Parser a a
arrayToBaseUrl urls =
    List.foldr ((</>) << Url.s) Url.top urls
