module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)
import List.Extra as List


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { highScores = []
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        ScoresRequested ->
            ( model
            , Lamdera.sendToFrontend clientId
                (TopScores (model.highScores |> List.take 6))
            )

        ScoreSaved score ->
            let
                newScores =
                    model.highScores
                        |> List.append [ { score | name = String.left 5 score.name } ]
                        |> List.sortBy .score
                        |> List.reverse
                        |> List.uniqueBy .name
            in
            ( { model | highScores = newScores }
            , Lamdera.sendToFrontend clientId (TopScores (newScores |> List.take 6))
            )

        NoOpToBackend ->
            ( model, Cmd.none )
