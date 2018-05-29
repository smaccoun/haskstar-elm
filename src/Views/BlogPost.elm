module Views.BlogPost exposing (..)

import Bulma.Columns exposing (..)
import Bulma.Modifiers exposing (Width(..))
import Date exposing (Date)
import Format exposing (dateToDateOnlyFormat)
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, style)
import Markdown exposing (toHtml)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)


viewBlogPost : Maybe Date -> BlogPost -> Html msg
viewBlogPost mbDate { title, content } =
    let
        fullPost =
            [ renderTitle mbDate title, renderContent content ]
    in
    div [ class "content" ]
        [ columns blogPostColumnsModifiers
            []
            [ column blogPostColumnModifiers [] fullPost
            ]
        ]


renderTitle : Maybe Date -> String -> Html msg
renderTitle mbLastUpdated title =
    let
        mainTitleView =
            toHtml Nothing <| "# " ++ title

        updatedSubTitle =
            case mbLastUpdated of
                Just lastUpdated ->
                    [ text <| dateToDateOnlyFormat lastUpdated ]

                Nothing ->
                    []
    in
    div [ class "has-text-left", style [ ( "paddingBottom", "12px" ) ] ]
        (mainTitleView ++ updatedSubTitle)


renderContent : String -> Html msg
renderContent content =
    div [ class "has-text-left" ]
        (toHtml Nothing content)


blogPostColumnsModifiers : ColumnsModifiers
blogPostColumnsModifiers =
    { multiline = False
    , gap = Gap0
    , display = TabletAndBeyond
    , centered = True
    }


blogPostColumnModifiers : ColumnModifiers
blogPostColumnModifiers =
    { offset = Auto
    , widths =
        { mobile = Just Width11
        , tablet = Just Width8
        , desktop = Just Width6
        , widescreen = Just Width6
        , fullHD = Just Width6
        }
    }
