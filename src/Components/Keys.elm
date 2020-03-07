module Components.Keys exposing
    ( Keys
    , animate
    , anykey
    , ascii
    , codes
    , directions
    , down
    , gamepadChange
    , getAscii
    , initial
    , keyChange
    , pressed
    )

import Components.Gamepad exposing (Gamepad)
import Dict exposing (Dict)


type alias Keys =
    Dict Int Float


initial : Keys
initial =
    Dict.empty


codes :
    { down : Int
    , enter : Int
    , left : Int
    , right : Int
    , space : Int
    , up : Int
    , q : Int
    , escape : Int
    , backspace : Int
    }
codes =
    { enter = 13
    , space = 32
    , escape = 27
    , q = 81
    , left = 37
    , right = 39
    , up = 38
    , down = 40
    , backspace = 8
    }


keyChange : Bool -> Int -> Keys -> Keys
keyChange on code keys =
    if on then
        if Dict.member code keys then
            keys

        else
            Dict.insert code 0 keys

    else
        Dict.remove code keys


gamepadChange : Gamepad -> Keys -> Keys
gamepadChange gamepad =
    keyChange gamepad.a codes.enter
        >> keyChange gamepad.a codes.up
        >> keyChange gamepad.left codes.left
        >> keyChange gamepad.right codes.right


animate : Float -> Keys -> Keys
animate elapsed =
    Dict.map (\_ -> (+) elapsed)


pressed : Int -> Keys -> Bool
pressed code keys =
    Dict.get code keys == Just 0


down : Int -> Keys -> Bool
down =
    Dict.member


anykey : Keys -> Bool
anykey =
    Dict.values >> List.member 0


directions : Keys -> { x : Float, y : Float }
directions keys =
    let
        direction a b =
            case ( a, b ) of
                ( True, False ) ->
                    -1

                ( False, True ) ->
                    1

                _ ->
                    0
    in
    { x = direction (down codes.left keys) (down codes.right keys)
    , y = direction (down codes.down keys) (down codes.up keys)
    }


ascii keys =
    keys
        |> Dict.keys
        |> List.any isAscii


isAscii code =
    code >= 33 && code <= 126


getAscii : Keys -> String
getAscii keys =
    keys
        |> Dict.filter (\code v -> v == 0 && isAscii code)
        |> Dict.keys
        |> List.map Char.fromCode
        |> String.fromList
