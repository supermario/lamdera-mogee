module Evergreen.Type.V1 exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Components.Components as Components exposing (Components)
import Components.Keys as Keys exposing (Keys, codes)
import Components.Menu as Menu exposing (Menu)
import Messages exposing (Msg(..))
import Systems.Systems as Systems exposing (Systems)
import Url exposing (Url)
import WebGL.Texture exposing (Error, Texture)


type GameState
    = Paused Menu
    | Playing
    | Dead
    | Initial Menu


type alias Score =
    { name : String, score : Int }


type alias FrontendModel =
    { systems : Systems
    , components : Components
    , state : GameState
    , lives : Int
    , score : Int
    , highScores : List Score
    , size : ( Int, Int )
    , padding : Int
    , sound : Bool
    , texture : Maybe Texture
    , sprite : Maybe Texture
    , font : Maybe Texture
    , keys : Keys
    , playerName : String

    -- , slides : Engine
    }


type alias BackendModel =
    { highScores : List Score
    }


type alias FrontendMsg =
    Msg


type ToBackend
    = ScoresRequested
    | ScoreSaved Score
    | NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = TopScores (List Score)
    | NoOpToFrontend
