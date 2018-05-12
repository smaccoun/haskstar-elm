module Components.Navbar exposing (..)

import Bulma.Components exposing (..)
import Html exposing (Html, div, text)
import Link
import Pages.Index exposing (AppPage(..))


viewNavbar : Bool -> AppPage -> (String -> msg) -> List NavbarLinkConfig -> Html msg
viewNavbar isMenuOpen curPage newUrlMsg navbarLinkConfigs =
    navbar navbarModifiers
        []
        [ navbarMenu isMenuOpen
            []
            [ navbarEnd [] [ viewNavbarLinks curPage newUrlMsg navbarLinkConfigs ]
            ]
        ]


viewNavbarLinks : AppPage -> (String -> msg) -> List NavbarLinkConfig -> Html msg
viewNavbarLinks curPage newUrlMsg navbarLinkConfigs =
    div []
        (List.map
            (viewNavbarLink curPage newUrlMsg)
            navbarLinkConfigs
        )


type alias NavbarLinkConfig =
    { displayText : String
    , linkUrl : String
    }


viewNavbarLink : AppPage -> (String -> msg) -> NavbarLinkConfig -> Html msg
viewNavbarLink curPage newUrlMsg { displayText, linkUrl } =
    let
        pageUrl =
            case curPage of
                WelcomeScreen _ ->
                    "/"

                _ ->
                    ""
    in
    navbarItemLink
        (pageUrl == linkUrl)
        [ Link.link (newUrlMsg linkUrl) ]
        [ text displayText ]


defaultNavLinks : List NavbarLinkConfig
defaultNavLinks =
    [ homeNavLink
    ]


homeNavLink : NavbarLinkConfig
homeNavLink =
    { displayText = "Home"
    , linkUrl = "/"
    }
