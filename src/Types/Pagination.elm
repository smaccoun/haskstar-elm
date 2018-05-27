module Types.Pagination exposing (..)

import Json.Decode exposing (Decoder, int, list, nullable, string)
import Json.Decode.Pipeline exposing (decode, required)


type alias PaginationContext =
    { currentPage : Int
    , previousPage : Maybe Int
    , nextPage : Maybe Int
    , totalPages : Int
    , count : Int
    , perPage : Int
    }


type alias PaginatedResult d =
    { pagination : PaginationContext
    , data : List d
    }


paginatedResultDecoder : Decoder entity -> Decoder (PaginatedResult entity)
paginatedResultDecoder entityDecoder =
    decode PaginatedResult
        |> required "pagination" paginationContextDecoder
        |> required "data" (list entityDecoder)


paginationContextDecoder : Decoder PaginationContext
paginationContextDecoder =
    decode PaginationContext
        |> required "currentPage" int
        |> required "previousPage" (nullable int)
        |> required "nextPage" (nullable int)
        |> required "totalPages" int
        |> required "count" int
        |> required "perPage" int
