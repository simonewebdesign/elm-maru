module Components.Section where

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JSON exposing ((:=))
import Components

type alias Model =
  { short_name : String
  , label : String
  , components : List Components.Model
  }


decoder : JSON.Decoder Model
decoder =
  JSON.object3 Model
    ("label" := JSON.string)
    ("short_name" := JSON.string)
    ("components" := Components.genericListDecoder)


--view : Html
view model =
  section [] [ text model.short_name, text model.label ]
