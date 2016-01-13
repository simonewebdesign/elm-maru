module Components.Section where

import Html exposing (..)
import Html.Attributes exposing (..)

--view : Html
view model =
  section [] [ text model.short_name, text model.label ]
