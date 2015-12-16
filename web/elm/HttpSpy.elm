module HttpSpy (..) where

import String
import Effects exposing (Effects)
import Signal exposing (Signal)
import Html exposing (Html)
import Html.Attributes exposing (..)
import StartApp


-- MODEL


type alias Request =
    { scheme : String
    , method : String
    , host : String
    , portNumber : Int
    , path : String
    , queryString : String
    , headers : List ( String, String )
    , remoteIp : String
    , body : String
    }


type alias Model =
    List Request


type Action
    = NoOp
    | Receive Request


init : ( Model, Effects Action )
init =
    ( [], Effects.none )



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        NoOp ->
            ( model, Effects.none )

        Receive request ->
            ( request :: model, Effects.none )



-- VIEW


portSuffix : Request -> String
portSuffix request =
    case ( request.scheme, request.portNumber ) of
        ( "http", 80 ) ->
            ""

        ( "https", 443 ) ->
            ""

        ( _, portNumber ) ->
            ":" ++ (toString portNumber)


querySuffix : Request -> String
querySuffix request =
    case request.queryString of
        "" ->
            ""

        qs ->
            "?" ++ qs


requestOneLiner : Request -> String
requestOneLiner request =
    request.method
        ++ " "
        ++ request.scheme
        ++ "://"
        ++ request.host
        ++ portSuffix (request)
        ++ request.path
        ++ querySuffix (request)


summaryView : Request -> Html
summaryView request =
    Html.div
        []
        [ Html.h3
            [ class "mt0" ]
            [ Html.text (requestOneLiner request) ]
        ]


headerEntry : ( String, String ) -> Html
headerEntry ( k, v ) =
    Html.tr
        []
        [ Html.td
            []
            [ Html.strong [] [ Html.text k ] ]
        , Html.td
            []
            [ Html.text v ]
        ]


headersView : List ( String, String ) -> Html
headersView headers =
    Html.div
        []
        [ Html.h3
            []
            [ Html.text "headers" ]
        , Html.div
            [ class "overflow-scroll" ]
            [ Html.table
                [ class "table-light" ]
                (List.map headerEntry headers)
            ]
        ]


bodyView : String -> Html
bodyView body =
    if body == "" then
        Html.div [] []
    else
        Html.div
            []
            [ Html.h3
                []
                [ Html.text "body" ]
            , Html.div
                [ class "ml2 mr2" ]
                [ Html.textarea
                    [ class "block col-12 field"
                    , readonly True
                    ]
                    [ Html.text body ]
                ]
            ]


requestView : Request -> Html
requestView request =
    Html.div
        [ class "mt2 p2 border" ]
        [ summaryView request
        , headersView request.headers
        , bodyView request.body
        ]


pageHeader : Html
pageHeader =
    Html.div
        []
        [ Html.h1
            []
            [ Html.text "http"
            , Html.span
                [ class "muted" ]
                [ Html.text "spy" ]
            ]
        , Html.p
            []
            [ Html.a
                [ href "https://github.com/jamesmacaulay/http_spy"
                , target "_blank"
                ]
                [ Html.text "source on github" ]
            ]
        , Html.p
            []
            [ Html.text "You are currently spying on the following URL:" ]
        , Html.p
            [ ]
            [ Html.input
                [ type' "text"
                , class "block field"
                , size (String.length requestUrl)
                , readonly True
                , value requestUrl
                ]
                []
            ]
        ]


requestListView : List Request -> Html
requestListView requests =
    if List.isEmpty requests then
        Html.div
            [ class "mt4" ]
            [ Html.p
                []
                [ Html.text "Try it out by entering the following command in your terminal to make a request:" ]
            , Html.div
                [ class "col-12 sm-col-10 md-col-8" ]
                [ Html.input
                    [ type' "text"
                    , class "block col-12 field"
                    , readonly True
                    , value ("curl --data \"hello from curl :)\" " ++ requestUrl)
                    ]
                    []
                ]
            ]
    else
        Html.div
            [ class "mt4" ]
            (List.map requestView (List.take 100 requests))


view : Signal.Address Action -> Model -> Html
view address model =
    Html.div
        [ class "m3" ]
        [ pageHeader
        , requestListView model
        ]



-- INPUTS


port requestUrl : String
port requests : Signal (Maybe Request)
requestActions : Signal Action
requestActions =
    Signal.filterMap (Maybe.map Receive) NoOp requests



-- APP


app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = [ requestActions ]
        }


main : Signal Html
main =
    app.html
