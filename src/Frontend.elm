module Frontend exposing (..)

import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events
    exposing
        ( onAnimationFrameDelta
        , onKeyDown
        , onKeyUp
        , onResize
        , onVisibilityChange
        )
import Components.Gamepad as Gamepad
import Html.Events exposing (keyCode)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode
import Lamdera
import Messages exposing (Msg(..))
import Model exposing (Model)
import Ports exposing (gamepad)
import Task exposing (Task)
import Types exposing (..)
import Url
import View
import View.Font as Font
import View.Sprite as Sprite


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        TopScores highScores ->
            ( { model | highScores = highScores }, Cmd.none )

        NoOpToFrontend ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta Animate
        , onKeyDown (Decode.map (KeyChange True) keyCode)
        , onKeyUp (Decode.map (KeyChange False) keyCode)
        , onResize Resize
        , onVisibilityChange VisibilityChange
        , gamepad (Gamepad.fromJson >> GamepadChange)
        ]


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Model.initial
    , Cmd.batch
        [ Sprite.loadTexture TextureLoaded
        , Sprite.loadSprite SpriteLoaded
        , Font.load FontLoaded
        , Task.perform (\{ viewport } -> Resize (round viewport.width) (round viewport.height)) getViewport
        ]
    )


app =
    Lamdera.frontend
        { init = \url key -> init Nothing
        , onUrlRequest = \_ -> Noop
        , onUrlChange = \_ -> Noop
        , update = Model.update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view =
            \model ->
                { title = "Mogee Live"
                , body = [ View.view model ]
                }
        }
