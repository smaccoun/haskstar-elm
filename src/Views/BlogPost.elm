module Views.BlogPost exposing (..)

import Bulma.Columns exposing (..)
import Bulma.Modifiers exposing (Width(..))
import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class, style)
import Markdown exposing (toHtml)
import Types.BlogPost exposing (BlogPost, BlogPostNew, blogPostDecoder, blogPostEncoder)


viewBlogPost : BlogPostNew -> Html msg
viewBlogPost { title, content } =
    let
        fullPost =
            [ renderTitle title, renderContent content ]
    in
    div [ class "content" ]
        [ columns blogPostColumnsModifiers
            []
            [ column blogPostColumnModifiers [] fullPost
            ]
        ]


renderTitle : String -> Html msg
renderTitle title =
    div [ class "has-text-centered", style [ ( "paddingBottom", "12px" ) ] ]
        (toHtml Nothing <| "# " ++ title)


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
