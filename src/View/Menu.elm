module View.Menu exposing (render)

import Animation exposing (Animation)
import Components.Menu as Menu exposing (HomeItem(..), Menu, MenuItem(..), MenuSection(..), PauseItem(..))
import Components.Transform as Transform exposing (Transform)
import Ease
import List
import Types exposing (Score)
import View.Color as Color
import View.Common exposing (rectangle)
import View.Font as Font exposing (Text)
import View.Sprite as Sprite exposing (Sprite)
import WebGL exposing (Entity)
import WebGL.Texture exposing (Texture)


second : Float
second =
    1000


titleAnimation : Animation
titleAnimation =
    Animation.animation 0
        |> Animation.from -24
        |> Animation.to 10
        |> Animation.ease Ease.outBounce
        |> Animation.duration (1 * second)
        |> Animation.delay (0.5 * second)


menuItemOffset : Float
menuItemOffset =
    9


cursorPosition : Menu -> Float -> ( Float, Float, Float )
cursorPosition { section } yOffset =
    if section == HomeSection StartTheGame || section == MenuSection SoundOnOff || section == PauseSection ResumeGame then
        ( 9, 3 + yOffset, 0 )

    else if section == HomeSection GoToHighScores || section == MenuSection GoToCredits || section == PauseSection EndGame then
        ( 9, 3 + menuItemOffset + yOffset, 0 )

    else
        ( 9, 3 + (menuItemOffset * 2) + yOffset, 0 )


homeTop : Float
homeTop =
    36


menuTop : Float
menuTop =
    20


roundFloat : Float -> Float
roundFloat =
    round >> toFloat


render : Bool -> Texture -> Texture -> Menu -> List Score -> String -> List Entity
render sound font sprite menu highScores playerName =
    case menu.section of
        HomeSection _ ->
            [ Font.render Color.white newGameText font ( 15, homeTop, 0 )
            , Font.render Color.white highScoresText font ( 15, homeTop + menuItemOffset, 0 )
            , Font.render Color.white menuText font ( 15, homeTop + (menuItemOffset * 2), 0 )
            , Sprite.render selectionSprite sprite (cursorPosition menu homeTop)
            , Sprite.render logoSprite sprite ( 3, Animation.animate menu.time titleAnimation |> roundFloat, 0 )
            ]

        PauseSection _ ->
            [ Font.render Color.white resumeText font ( 15, homeTop, 0 )
            , Font.render Color.white endText font ( 15, homeTop + menuItemOffset, 0 )
            , Sprite.render selectionSprite sprite (cursorPosition menu homeTop)
            ]

        MenuSection _ ->
            [ Font.render Color.white (soundText sound) font ( 15, menuTop, 0 )
            , Font.render Color.white creditsText font ( 15, menuTop + menuItemOffset, 0 )
            , Font.render Color.white slidesText font ( 15, menuTop + (menuItemOffset * 2), 0 )
            , Sprite.render selectionSprite sprite (cursorPosition menu menuTop)
            ]

        HighScoresSection ->
            let
                viewScore i score =
                    let
                        rank =
                            ord (i + 1) |> Font.text

                        name =
                            score.name |> String.left 5 |> Font.text

                        score_ =
                            score.score |> String.fromInt |> Font.text

                        heightOffset =
                            8 * toFloat i
                    in
                    [ Font.render Color.yellow rank font ( 2, 12 + heightOffset, 0 )
                    , Font.render Color.white name font ( 16, 12 + heightOffset, 0 )
                    , Font.render Color.yellow score_ font ( 49, 12 + heightOffset, 0 )
                    ]
            in
            highScores
                |> List.indexedMap viewScore
                |> List.concat
                |> (++) [ Font.render Color.yellow (Font.text "top players") font ( 12, 0, 0 ) ]

        ScoreEnterNameSection ->
            [ Font.render Color.yellow (Font.text "enter name") font ( 12, 0, 0 )
            , Font.render Color.yellow (Font.text playerName) font ( 17, 20, 0 )
            , rectangle False (Transform 35 1 14 30) 0 Color.yellow
            ]

        CreditsSection ->
            [ Font.render Color.white creditsScreenText font ( 2, 10, 0 )
            ]

        SlidesSection ->
            []


ord i =
    case i of
        1 ->
            "1st"

        2 ->
            "2nd"

        3 ->
            "3rd"

        4 ->
            "4th"

        5 ->
            "5th"

        6 ->
            "6th"

        7 ->
            "7th"

        8 ->
            "8th"

        9 ->
            "9th"

        10 ->
            "10th"

        _ ->
            "???"


newGameText : Text
newGameText =
    Font.text "new game"


highScoresText : Text
highScoresText =
    Font.text "high scores"


menuText : Text
menuText =
    Font.text "menu"


resumeText : Text
resumeText =
    Font.text "resume"


endText : Text
endText =
    Font.text "end game"


soundText : Bool -> Text
soundText on =
    if on then
        soundOnText

    else
        soundOffText


soundOnText : Text
soundOnText =
    Font.text "sound: on"


soundOffText : Text
soundOffText =
    Font.text "sound: off"


creditsText : Text
creditsText =
    Font.text "credits"


slidesText : Text
slidesText =
    Font.text "slides"


logoSprite : Sprite
logoSprite =
    Sprite.sprite "logo"


creditsScreenText : Text
creditsScreenText =
    Font.text "Art, code, sound:\n@nadyakzmn,\n@unsoundscapes,\n@carlospazuzu."


selectionSprite : Sprite
selectionSprite =
    Sprite.sprite "arrow"
