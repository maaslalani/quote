module Main exposing (main)

import Browser
import Css exposing (..)
import Html.Styled exposing (Html, a, div, kbd, label, text, toUnstyled)
import Html.Styled.Attributes exposing (contenteditable, css)
import Html.Styled.Events exposing (onClick)


type alias Quote =
    { text : String, author : String }


type alias Theme =
    { font : String, foreground : String, background : String }


type alias Size =
    { width : Float, height : Float }


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


view : Model -> Html Msg
view model =
    let
        theme =
            model.theme
    in
    div [ css [] ]
        [ div []
            [ div
                -- Quote Container
                [ css
                    [ fontFamilies [ theme.font ]
                    , height (px model.size.height)
                    , width (px model.size.width)
                    , displayFlex
                    , flexDirection column
                    , justifyContent center
                    , boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)
                    , margin auto
                    , borderRadius (px 16)
                    ]
                ]
                [ -- Quote Text
                  div
                    [ css
                        [ fontSize (em 1.35)
                        , outline none
                        , width (pct 60)
                        , margin2 (px 0) auto
                        , marginBottom (em 0.5)
                        ]
                    , contenteditable True
                    ]
                    [ text model.quote.text ]
                , -- Quote Author
                  div
                    [ css
                        [ fontSize (em 1)
                        , width (pct 60)
                        , margin2 (px 0) auto
                        , outline none
                        ]
                    , contenteditable True
                    ]
                    [ text model.quote.author ]
                ]
            ]
        , div []
            [ div [ css [ displayFlex ] ]
                [ div []
                    [ editorLabel [ text "Theme" ]
                    , div
                        [ css [ displayFlex, width (em 15), flexWrap wrap ] ]
                        [ themeButton theme "#333333" "#FFFFFF"
                        , themeButton theme "#333333" "#EDEDE9"
                        , themeButton theme "#333333" "#D6CCC2"
                        , themeButton theme "#333333" "#F5EBE0"
                        , themeButton theme "#333333" "#E3D5CA"
                        , themeButton theme "#FEFEFE" "#D5BDAF"
                        , themeButton theme "#FEFEFE" "#EEE4E1"
                        , themeButton theme "#333333" "#E7D8C9"
                        , themeButton theme "#FFFFFF" "#E6BEAE"
                        , themeButton theme "#EFEFEF" "#E6BEAE"
                        ]
                    ]
                ]
            , div
                []
                [ editorLabel [ text "Size" ]
                , sizeButton 250
                , sizeButton 400
                , sizeButton 600
                ]
            , div
                []
                [ editorLabel [ text "Font" ]
                , fontButton theme "serif"
                , fontButton theme "sans-serif"
                , fontButton theme "monospace"
                ]
            , div
                []
                [ editorLabel
                    [ text "Export"
                    , kbd
                        [ css
                            [ padding2 (px 3) (px 5)
                            , fontSize (px 11)
                            , fontFamilies [ "ui-monospace", "SFMono-Regular", "SF Mono", "Menlo", "Consolas", "monospace" ]
                            , color (hex "1f2329")
                            , backgroundColor (hex "f6f8fa")
                            , border3 (px 1) solid (hex "e7ebee")
                            , borderRadius (px 6)
                            , borderBottomColor (hex "e7ebee")
                            , boxShadow5 inset (px 0) (px -1) (px 0) (hex "e7ebee")
                            , marginLeft (px 5)
                            , lineHeight (px 10)
                            , verticalAlign middle
                            ]
                        ]
                        [ text "⌘ S" ]
                    ]
                ]
            ]
        ]


editorLabel : List (Html msg) -> Html msg
editorLabel children =
    label
        [ css
            [ fontSize (em 0.8)
            , color (hex "635852")
            , display block
            ]
        ]
        children


themeButton : Theme -> String -> String -> Html Msg
themeButton theme fg bg =
    a
        [ css
            [ color (hex fg)
            , backgroundColor (hex bg)
            , displayFlex
            , justifyContent center
            , alignItems center
            , width (px 24)
            , height (px 24)
            , fontSize (em 0.75)
            , borderRadius (px 16)
            , border3 (px 1) solid (rgba 0 0 0 0.2)
            , margin4 (em 0.75) (em 0.75) (px 0) (px 0)
            ]
        , onClick (SetTheme { theme | foreground = fg, background = bg })
        ]
        [ text " F " ]


sizeButton : Float -> Html Msg
sizeButton size =
    a [ onClick (SetSize { width = size, height = size }) ] [ text (String.fromFloat size) ]


fontButton : Theme -> String -> Html Msg
fontButton theme font =
    a [ onClick (SetTheme { theme | font = font }) ] [ text font ]


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
        , view = view >> toUnstyled
        }
