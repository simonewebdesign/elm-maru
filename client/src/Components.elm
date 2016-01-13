module Components where

import Json.Decode as JSON exposing ((:=))

type alias Model =
  { short_name : String
  , label : String
  }

genericListDecoder : JSON.Decoder (List Model)
genericListDecoder =
  JSON.list genericDecoder


genericDecoder : JSON.Decoder Model
genericDecoder =
  JSON.object2 Model
    ("label" := JSON.string)
    ("short_name" := JSON.string)
