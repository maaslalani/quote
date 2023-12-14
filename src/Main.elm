module Main exposing (main)

import Browser
import Html exposing (Html, div, label, text)
import Html.Attributes exposing (class, classList, contenteditable, style)


type alias Quote =
    { text : String, author : String }


type alias Theme =
    { font : String, foreground : String, background : String }


type alias Size =
    { width : Int, height : Int }


type alias Model =
    { quote : Quote, theme : Theme, size : Size }


type Msg
    = SetQuote Quote
    | SetTheme Theme
    | SetSize Size


init : Model
init =
    { quote =
        { text = "Be yourself; everyone else is already taken."
        , author = "— Oscar Wilde"
        }
    , theme =
        { foreground = "#000000"
        , background = "#FFFFFF"
        , font = "Times New Roman"
        }
    , size =
        { width = 400
        , height = 400
        }
    }


stylesheet model =
    { container =
        [ style "width" "100vw"
        , style "height" "100vh"
        , style "display" "flex"
        , style "align-items" "center"
        , style "justify-content" "center"
        ]
    , quoteContainer =
        [ style "background-color" model.theme.background
        , style "box-shadow" "0 0 20px rgba(0, 0, 0, 0.1)"
        , style "border-radius" "12px"
        , style "border" "1px solid rgba(0, 0, 0, 0.1)"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "font-family" model.theme.font
        , style "height" (String.fromInt model.size.height ++ "px")
        , style "width" (String.fromInt model.size.width ++ "px")
        ]
    , quote =
        [ style "font-size" "1.35em"
        , style "color" model.theme.foreground
        , style "outline" "none"
        , style "margin" "2% 20%"
        ]
    , author =
        [ style "font-size" "1em"
        , style "color" model.theme.foreground
        , style "outline" "none"
        , style "margin" "1% 20%"
        ]
    }


editorSection name =
    div [ class "editor-section" ]
        [ label [] [ text name ] ]


view : Model -> Html msg
view model =
    let
        styles =
            stylesheet model
    in
    div styles.container
        [ div styles.quoteContainer
            [ div
                (styles.quote ++ [ contenteditable True ])
                [ text model.quote.text ]
            , div
                (styles.author ++ [ contenteditable True ])
                [ text model.quote.author ]
            ]
        , div [ class "editor-container" ]
            [ editorSection "Theme"
            , editorSection "Size"
            , editorSection "Font"
            ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetQuote quote ->
            { model | quote = quote }

        SetTheme theme ->
            { model | theme = theme }

        SetSize size ->
            { model | size = size }


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
