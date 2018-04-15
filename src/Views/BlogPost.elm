module Views.BlogPost exposing (..)

import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (class)
import Markdown exposing (toHtml)
import Types.BlogPost exposing (BlogPost, blogPostDecoder, blogPostEncoder)


viewBlogPost : BlogPost -> Html msg
viewBlogPost { title, content } =
    let
        renderTitle =
            toHtml Nothing <| "# " ++ title

        renderContent =
            toHtml Nothing content

        fullPost =
            List.concat [ renderTitle, renderContent ]
    in
    div [ class "content" ] fullPost
