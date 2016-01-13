module Components.Section where

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JSON exposing ((:=))

type alias Model =
  { short_name : String
  , label : String
  }


decoder : JSON.Decoder Model
decoder =
  JSON.object2 Model
    ("label" := JSON.string)
    ("short_name" := JSON.string)


--view : Html
view model =
  section [] [ text model.short_name, text model.label ]
