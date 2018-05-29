module Types.MasterEntity exposing (..)

import Date exposing (Date)
import Json.Decode exposing (Decoder, int, list, nullable, string)
import Json.Decode.Extra exposing (date)
import Json.Decode.Pipeline exposing (decode, required)


type alias MasterEntity baseEntity =
    { meta : Meta
    , baseEntity : baseEntity
    }


type alias Meta =
    { appId : String
    , updatedAt : Date
    , createdAt : Date
    }


metaDecoder : Decoder Meta
metaDecoder =
    decode Meta
        |> required "id" string
        |> required "updatedAt" date
        |> required "createdAt" date


entityDecoder : Decoder subEntity -> Decoder (MasterEntity subEntity)
entityDecoder subDecoder =
    decode MasterEntity
        |> required "meta" metaDecoder
        |> required "baseEntity" subDecoder
