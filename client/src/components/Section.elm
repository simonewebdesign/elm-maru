module Components.Section where

import Html exposing (..)
--import Html.Attributes exposing (..)
import Json.Decode as JSON exposing ((:=))
import Components
import Components.Text

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
    --("components" := Components.genericListDecoder)
    ("components" := (JSON.list Components.Text.decoder))


view : Model -> Html
view model =
  let
    title = h1 [] [ text model.label ]
    sectionContent = [title] ++ List.map Components.Text.view model.components
  in
    section [] sectionContent
