module HttpSpy where

import Effects exposing (Effects)
import Signal exposing (Signal)
import Html exposing (Html)
import Html.Attributes exposing (..)
import StartApp

port requestUrl : String

port requests : Signal (Maybe Request)

type alias Request =
  { scheme : String
  , method : String
  , host : String
  , portNumber : Int
  , path : String
  , queryString : String
  , headers : List (String, String)
  , remoteIp : String
  }

type alias Model = List Request

type Action
  = NoOp
  | Receive Request

init : (Model, Effects Action)
init = ([], Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      (model, Effects.none)
    Receive request ->
      (request :: model, Effects.none)

portSuffix : Request -> String
portSuffix request =
  case (request.scheme, request.portNumber) of
    ("http", 80) -> ""
    ("https", 443) -> ""
    (_, portNumber) -> ":" ++ (toString portNumber)

querySuffix : Request -> String
querySuffix request =
  case request.queryString of
    "" -> ""
    qs -> "?" ++ qs

requestOneLiner : Request -> String
requestOneLiner request =
  request.method
    ++ " "
    ++ request.scheme
    ++ "://"
    ++ request.host
    ++ portSuffix(request)
    ++ request.path
    ++ querySuffix(request)

requestView : Request -> Html
requestView request =
  Html.div
    [ ]
    [ Html.h3
        [ ]
        [ Html.text (requestOneLiner request)]]

header : Html
header =
  Html.div
    [ ]
    [ Html.h1 [] [ Html.text "HttpSpy" ]
    , Html.text "Make some requests to "
    , Html.input
        [ readonly True
        , value requestUrl
        , size 40]
        [ ]]

view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    [ ]
    (header :: List.map requestView model)

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
