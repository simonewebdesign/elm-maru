module Main where

import Graphics.Element as Element
import Html exposing (..)
--import Html.Attributes as Attr
--import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as JSON exposing ((:=))
import Task exposing (Task, andThen, onError)
import Components.Section
--import Components.Text

-- MODEL

type alias Model =
  { sections : List Components.Section.Model
  , error : String
  }

-- Represents the entire JSON configuration object
type alias MainConfiguration =
  { configuration : Configuration
  }

type alias Configuration =
  { sections : List Components.Section.Model
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


componentsListDecoder : JSON.Decoder (List Components.Section.Model)
componentsListDecoder =
  JSON.list Components.Section.decoder



-- UPDATE

-- These are all the possible actions that can change our application state.
type Action
  = NoOp
  | SetSections (List Components.Section.Model)
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


-- To actually send the first request, it needs to pass through a port.
port runner : Task Http.Error ()
port runner =
  let
    extractSections {sections} = sections
  in
    getSections
    `andThen` (\{configuration} -> Signal.send actions.address (SetSections (extractSections configuration)))
    `onError` (\error -> Signal.send actions.address (SetError (toString error)))


-- VIEW

-- The main view for the application.
view : Model -> Html
view model =
  let
    sections = List.map Components.Section.view model.sections
    pContent = sections ++ [ Element.show model |> Html.fromElement ]
  in
    p [] pContent
