module Types.BlogPost exposing (..)

import Http
import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode


type alias BlogPost =
    { blogPostId : String
    , title : String
    , content : String
    }


blogPostDecoder : Decoder BlogPost
blogPostDecoder =
    decode BlogPost
        |> required "blogPostId" string
        |> required "title" string
        |> required "content" string


blogPostEncoder : BlogPost -> Json.Encode.Value
blogPostEncoder { title, content } =
    Json.Encode.object
        [ ( "title", Json.Encode.string title )
        , ( "content", Json.Encode.string content )
        ]
