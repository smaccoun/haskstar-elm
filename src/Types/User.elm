module Types.User exposing (..)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias User =
    { userId : String
    , email : String
    }


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "userId" string
        |> required "email" string
