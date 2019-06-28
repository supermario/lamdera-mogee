module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Url exposing (Url)


type alias FrontendModel =
    Model


type alias BackendModel =
    { message : String
    }


type alias FrontendMsg =
    Msg



-- = UrlClicked UrlRequest
-- | UrlChanged Url
-- | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
