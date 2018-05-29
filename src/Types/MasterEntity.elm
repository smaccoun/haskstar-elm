module Types.MasterEntity exposing (..)

import Date exposing (Date)
import Json.Decode exposing (Decoder, int, list, nullable, string)
import Json.Decode.Extra exposing (date)
import Json.Decode.Pipeline exposing (decode, required)


type alias MasterEntity subEntity =
    { appId : String
    , subEntity : subEntity
    , updatedAt : Date
    , createdAt : Date
    }


entityDecoder : Decoder subEntity -> Decoder (MasterEntity subEntity)
entityDecoder subDecoder =
    decode MasterEntity
        |> required "appId" string
        |> required "baseEntity" subDecoder
        |> required "updatedAt" date
        |> required "createdAt" date
