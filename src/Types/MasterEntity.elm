module Types.MasterEntity exposing (..)

import Data.Extra exposing (date)
import Date exposing (Date)
import Json.Decode exposing (Decoder, int, list, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias MasterEntity subEntity =
    { meta : Meta
    , subEntity : subEntity
    }


type alias Meta =
    { id : String
    , updatedAt : String
    , createdAt : String
    }


metaDecoder : Decoder subEntity -> Decoder (MasterEntity subEntity)
metaDecoder subDecoder =
    decode MasterEntity
        |> required "id" string
        |> required "updatedAt" date
        |> required "createdAt" date


entityDecoder : Decoder subEntity -> Decoder (MasterEntity subEntity)
entityDecoder subDecoder =
    decode MasterEntity
        |> required "meta" metaDecoder
        |> required "baseEntity" subDecoder
