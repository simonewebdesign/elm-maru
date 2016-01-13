module Main where

import Graphics.Element as Element
import Html exposing (..)
--import Html.Attributes as Attr
--import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as JSON exposing ((:=))
import Task exposing (Task, andThen, onError)


-- MODEL

type alias Model =
  { configuration : Configuration
  , error : String
  }


-- Represents the entire JSON configuration object
type alias MainConfiguration =
  { configuration : Configuration
  }

type alias Configuration =
  { sections : List Component
  }

type alias Component =
  { short_name : String
  , label : String
  }

initialModel : Model
initialModel =
  { configuration = { sections = [] }
  , error = ""
  }


-- The first request has to be decoded.
modelConfigurationDecoder : JSON.Decoder MainConfiguration
modelConfigurationDecoder =
  JSON.object1 MainConfiguration ("configuration" := modelDecoder)


modelDecoder : JSON.Decoder Configuration
modelDecoder =
  JSON.object1 Configuration
    ("sections" := componentsListDecoder)


componentsListDecoder : JSON.Decoder (List Component)
componentsListDecoder =
  JSON.list componentDecoder


componentDecoder : JSON.Decoder Component
componentDecoder =
  JSON.object2 Component
    ("label" := JSON.string)
    ("short_name" := JSON.string)



-- UPDATE

-- These are all the possible actions that can change our application state.
type Action
  = NoOp
  | SetConfiguration Configuration
  | SetError String


-- The only purpose of the update function is to step the model forward.
-- This can be done only via an Action.
update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SetConfiguration config ->
      { model | configuration = config }

    SetError error ->
      { model | error = error }

-- SIGNALS

-- The application's entry point.
main : Signal Html
main =
  Signal.map view state


-- This is where all the state lives.
state : Signal Model
state = Signal.foldp update initialModel actions.signal


-- Send messages to this mailbox's address to step the state forward.
actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


-- The first request.
getConfiguration : Task Http.Error MainConfiguration
getConfiguration =
  Http.get modelConfigurationDecoder "http://localhost:8880/api"


-- To actually send the first request, it needs to pass through a port.
port runner : Task Http.Error ()
port runner =
  getConfiguration
  `andThen` (\{configuration} -> Signal.send actions.address (SetConfiguration configuration))
  `onError` (\error -> Signal.send actions.address (SetError (toString error)))
  --`andThen` (SetConfiguration >> Signal.send actions.address)
  --`onError` (SetError >> Signal.send actions.address)


-- VIEW

-- The main view for the application.
view : Model -> Html
view model =
  p []
  [ Element.show model |> Html.fromElement
  ]
