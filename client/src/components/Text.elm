module Components.Text where

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
    ("short_name" := JSON.string)
    ("label" := JSON.string)


view : Model -> Html
view model =
  h4 [class "text"] [ text ("short name: " ++ model.short_name), text ("label: " ++ model.label) ]
