module Types.MasterEntity exposing (..)

import Data.Extra exposing (date)
import Date exposing (Date)
import Json.Decode exposing (Decoder, int, list, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias MasterEntity subEntity =
    { id : String
    , subEntity : subEntity
    , updatedAt : Date
    , createdAt : Date
    }


entityDecoder : Decoder subEntity -> Decoder (MasterEntity subEntity)
entityDecoder subDecoder =
    decode MasterEntity
        |> required "appId"
        |> required "baseEntity" subDecoder
        |> required "updatedAt" date
        |> required "createdAt" date
