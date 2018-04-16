module Pages.Index exposing (..)

import Components.BlogPost as BP
import Components.BlogPostList as BPL
import Components.LoginPanel as LoginPanel
import Html exposing (Html, div, text)
import Navigation exposing (Location)
import Pages.Admin.Index as Admin exposing (AdminRoute(..))
import Pages.LoginPage as LoginPage
import Pages.Welcome as WelcomePage exposing (viewWelcomeScreen)
import Server.Config
import UrlParser as Url exposing ((</>), (<?>), s, top)


type AppPage
    = Error404
    | WelcomeScreen WelcomePage.Model
    | LoginPage LoginPanel.Model
    | AdminPageW Admin.AdminPage
    | BlogPostList BPL.Model
    | BlogPostView BP.Model


type AppPageMsg
    = WelcomePageMsg WelcomePage.Msg
    | LoginPageMsg LoginPanel.Msg
    | AdminPageMsg Admin.AdminPageMsg
    | BlogPostListMsg BPL.Msg
    | BlogPostViewMsg BP.Msg


type Route
    = WelcomeRoute
    | Login
    | AdminRouteW AdminRoute
    | BlogPostRoute CrudRoute


initializePageFromRoute : Server.Config.Context -> Route -> ( AppPage, Cmd AppPageMsg )
initializePageFromRoute serverContext route =
    case route of
        WelcomeRoute ->
            let
                ( wModel, wCmd ) =
                    WelcomePage.init serverContext
            in
            ( WelcomeScreen wModel, Cmd.map WelcomePageMsg wCmd )

        Login ->
            ( LoginPage (LoginPanel.init serverContext), Cmd.none )

        AdminRouteW adminRoute ->
            let
                ( adminPage, adminPageCmd ) =
                    Admin.initializePageFromRoute serverContext adminRoute
            in
            ( AdminPageW adminPage, Cmd.map AdminPageMsg adminPageCmd )

        BlogPostRoute crud ->
            case crud of
                Index ->
                    let
                        ( bpModel, bpCmd ) =
                            BPL.init serverContext
                    in
                    ( BlogPostList bpModel, Cmd.map BlogPostListMsg bpCmd )

                Show id ->
                    let
                        ( bpModel, bpCmd ) =
                            BP.init serverContext id
                    in
                    ( BlogPostView bpModel, Cmd.map BlogPostViewMsg bpCmd )

                _ ->
                    Error404 ! []


locationToPage : Server.Config.Context -> Location -> ( AppPage, Cmd AppPageMsg )
locationToPage serverContext location =
    Url.parsePath routes location
        |> Maybe.map (initializePageFromRoute serverContext)
        |> Maybe.withDefault ( Error404, Cmd.none )


routes : Url.Parser (Route -> Route) Route
routes =
    let
        unprotected =
            [ Url.map WelcomeRoute top
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
        WelcomePageMsg wMsg ->
            case currentPage of
                WelcomeScreen wModel ->
                    let
                        ( uwModel, cmd ) =
                            WelcomePage.update wMsg wModel
                    in
                    ( WelcomeScreen uwModel, Cmd.map WelcomePageMsg cmd )

                _ ->
                    ( currentPage, Cmd.none )

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

        BlogPostViewMsg bpMsg ->
            case currentPage of
                BlogPostView bpModel ->
                    let
                        ( updatedBPModel, bpCmd ) =
                            BP.update bpMsg bpModel
                    in
                    ( BlogPostView updatedBPModel, Cmd.map BlogPostViewMsg bpCmd )

                _ ->
                    ( currentPage, Cmd.none )


view : AppPage -> Html AppPageMsg
view page =
    case page of
        Error404 ->
            div [] [ text "Invalid URL" ]

        LoginPage loginPageModel ->
            Html.map LoginPageMsg <| LoginPage.view loginPageModel

        AdminPageW adminPage ->
            Html.map AdminPageMsg <| Admin.viewAdminPage adminPage

        WelcomeScreen m ->
            Html.map WelcomePageMsg <| viewWelcomeScreen m

        BlogPostList m ->
            Html.map BlogPostListMsg <| BPL.view m

        BlogPostView bpm ->
            Html.map BlogPostViewMsg <| BP.view bpm



{- CRUD Resource Helpers -}


type CrudRoute
    = Index
    | Show String
    | Edit String
    | New


type alias BaseParser a =
    Url.Parser (Route -> a) a


makeDefaultResourceRoutes : List String -> (CrudRoute -> Route) -> List (BaseParser Route)
makeDefaultResourceRoutes urlList crudRoute =
    let
        baseUrl =
            arrayToBaseUrl urlList
    in
    [ Url.map (\u -> crudRoute (Show u)) (baseUrl </> Url.string)
    , Url.map (\u -> crudRoute (Edit u)) (baseUrl </> Url.string </> Url.s "edit")
    , Url.map (crudRoute Index) baseUrl
    , Url.map (crudRoute New) (baseUrl </> Url.s "new")
    ]


arrayToBaseUrl : List String -> Url.Parser a a
arrayToBaseUrl urls =
    List.foldr ((</>) << Url.s) Url.top urls
