module Main where

import Graphics.Element as Element
import Html exposing (..)
--import Html.Attributes as Attr
--import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as JSON exposing ((:=))
import Task exposing (Task, andThen, onError)

-- Components
import Components.Section

-- MODEL

type alias Model =
  { sections : List Component
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
  { sections = []
  , error = ""
  }


-- DECODERS

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
  | SetSections (List Component)
  | SetError String


-- The only purpose of the update function is to step the model forward.
-- This can be done only via an Action.
update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model

    SetSections sections ->
      { model | sections = sections }

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
getSections : Task Http.Error MainConfiguration
getSections =
  Http.get modelConfigurationDecoder "http://localhost:8880/api"


-- Get a record that has a 'sections' property, and extract its value.
-- Useful because we want to keep the Model simple by not having a
-- 'configuration' property.
extractSections : { configuration | sections : List Component } -> List Component
extractSections {sections} =
  sections


-- To actually send the first request, it needs to pass through a port.
port runner : Task Http.Error ()
port runner =
  getSections
  `andThen` (\{configuration} -> Signal.send actions.address (SetSections (extractSections configuration)))
  `onError` (\error -> Signal.send actions.address (SetError (toString error)))
  --`andThen` (SetConfiguration >> Signal.send actions.address)
  --`onError` (SetError >> Signal.send actions.address)


-- VIEW

-- The main view for the application.
view : Model -> Html
view model =
  let
    sections = List.map Components.Section.view model.sections
    pContent = sections ++ [ Element.show model |> Html.fromElement ]
  in
    p [] pContent
