module HttpSpy where

import Effects exposing (Effects)
import Signal exposing (Signal)
import Html exposing (Html)
import Html.Attributes exposing (..)
import StartApp

type alias Request =
  { method : String,
    body : String
  }

type alias Model = List Request

type Action
  = NoOp
  | Receive Request

init : (Model, Effects Action)
init = ([Request "post" "hello"], Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    Receive request ->
      (request :: model, Effects.none)

requestView : Request -> Html
requestView request =
  toString request |> Html.text

view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    [ ]
    (List.map requestView model)

port requests : Signal (Maybe Request)

requestActions : Signal Action
requestActions = Signal.filterMap (Maybe.map Receive) NoOp requests

app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [requestActions]
    }

main : Signal Html
main = app.html
