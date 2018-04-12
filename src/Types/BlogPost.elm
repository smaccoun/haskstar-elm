module Types.BlogPost exposing (..)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias BlogPost =
    { title : String
    , content : String
    }


blogPostDecoder : Decoder BlogPost
blogPostDecoder =
    decode BlogPost
        |> required "title" string
        |> required "content" string
