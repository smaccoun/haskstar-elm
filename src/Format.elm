module Format exposing (..)

import Date exposing (Date)
import Date.Extra


dateToTimeFormat : Date -> String
dateToTimeFormat dt =
    Date.Extra.toFormattedString "MMMM d, y h:mm a" dt


dateToDateOnlyFormat : Date -> String
dateToDateOnlyFormat dt =
    Date.Extra.toFormattedString "MMMM d, y" dt


dateToOnlyTimeFormat : Date -> String
dateToOnlyTimeFormat dt =
    Date.Extra.toFormattedString "h:mm" dt
