module Section where

import Html exposing (..)
import Html.Attributes exposing (..)

--view : Html
view model =
  h2 [class "section"] [ text model.short_name, text model.label ]
