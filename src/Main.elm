module Main exposing (main)

import Browser
import Css exposing (..)
import Css.Transitions as Transitions exposing (transition)
import Html.Styled exposing (Html, a, div, kbd, label, text, toUnstyled)
import Html.Styled.Attributes exposing (contenteditable, css)
import Html.Styled.Events exposing (onClick)
import Svg.Styled exposing (rect, svg)
import Svg.Styled.Attributes as Attributes exposing (fill, x, y)


type alias Quote =
    { text : String, author : String }


type alias Theme =
    { font : String, foreground : String, background : String }


type alias Size =
    { width : Float, height : Float }


type Align
    = Left
    | Center
    | Right


type alias Model =
    { quote : Quote, theme : Theme, size : Size, align : Align }


type Msg
    = SetQuote Quote
    | SetTheme Theme
    | SetAlign Align
    | SetSize Size


stylesheet model =
    { container =
        css
            [ displayFlex
            , alignItems center
            , flexDirection column
            , height (vh 100)
            ]
    , quoteContainer =
        css
            [ flex (int 3)
            , displayFlex
            , alignItems center
            , textAlign
                (case model.align of
                    Right ->
                        right

                    Center ->
                        center

                    Left ->
                        left
                )
            ]
    , quoteWrapper =
        css
            [ fontFamilies [ model.theme.font ]
            , height (px model.size.height)
            , width (px model.size.width)
            , backgroundColor (hex model.theme.background)
            , color (hex model.theme.foreground)
            , displayFlex
            , flexDirection column
            , justifyContent center
            , boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)
            , margin auto
            , border3 (px 1) solid (hex "e7ebee")
            , borderRadius (px 16)
            , transition
                [ Transitions.background 250
                , Transitions.color 250
                , Transitions.width 250
                , Transitions.height 250
                ]
            ]
    , quoteText =
        css
            [ fontSize (em 1.35)
            , outline none
            , width (pct 60)
            , margin2 (px 0) auto
            , marginBottom (em 0.5)
            ]
    , quoteAuthor =
        css
            [ fontSize (em 1)
            , width (pct 60)
            , margin2 (px 0) auto
            , outline none
            ]
    , editorContainer =
        css
            [ flex (int 1)
            ]
    , editorWrapper =
        css
            [ display inlineFlex
            , backgroundColor (hex "fff")
            , boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)
            , padding2 (em 1.5) (em 0.75)
            , borderRadius (px 16)
            , border3 (px 1) solid (hex "e7ebee")
            ]
    , editorSection =
        css
            [ margin2 (px 0) (em 0.75)
            ]
    , buttonGroup =
        css
            [ backgroundColor (hex "f4f4f5")
            , padding2 (em 0.3) (em 0.2)
            , displayFlex
            , justifyContent center
            , alignItems center
            , borderRadius (em 0.5)
            ]
    , button =
        css
            [ backgroundColor (hex "f4f4f5")
            , color (hex "83838b")
            , padding2 (em 0.4) (em 0.65)
            , borderRadius (em 0.5)
            , margin2 (em 0) (em 0.25)
            , whiteSpace noWrap
            , fontSize (em 0.8)
            , cursor default
            , transition
                [ Transitions.backgroundColor 250
                ]
            , hover
                [ color (hex "1e1e20")
                ]
            ]
    , activeButton =
        css
            [ backgroundColor (hex "fff")
            , color (hex "1e1e20")
            , boxShadow5 (px 0) (px 1) (px 3) (px 0) (rgba 0 0 0 0.1)
            ]
    , exportButton =
        css
            [ backgroundColor (hex "18181b")
            , color (hex "fafafa")
            , padding2 (em 0.6) (em 2)
            , borderRadius (em 0.5)
            , fontSize (em 0.9)
            , letterSpacing (px 0.25)
            , boxShadow5 (px 0) (px 1) (px 3) (px 0) (rgba 0 0 0 0.1)
            , fontWeight (int 400)
            , fontFamily sansSerif
            , cursor pointer
            , hover
                [ backgroundColor (hex "2e2e34")
                ]
            ]
    , kbd =
        css
            [ padding2 (px 2) (px 5)
            , fontSize (px 10)
            , fontFamilies
                [ "ui-monospace"
                , "SFMono-Regular"
                , "SF Mono"
                , "Menlo"
                , "Consolas"
                , "monospace"
                ]
            , color (hex "1f2329")
            , backgroundColor (hex "f6f8fa")
            , border3 (px 1) solid (hex "e7ebee")
            , borderRadius (px 6)
            , borderBottomColor (hex "e7ebee")
            , boxShadow5 inset (px 0) (px -1) (px 0) (hex "e7ebee")
            , marginLeft (px 5)
            ]
    }


init : Model
init =
    { quote =
        { text = "Be yourself; everyone else is already taken."
        , author = "— Oscar Wilde"
        }
    , theme =
        { foreground = "#333333"
        , background = "#FFFFFF"
        , font = "serif"
        }
    , size =
        { width = 400
        , height = 400
        }
    , align = Left
    }


view : Model -> Html Msg
view model =
    let
        styles =
            stylesheet model
    in
    div [ styles.container ]
        [ div [ styles.quoteContainer ]
            [ div
                [ styles.quoteWrapper ]
                [ div
                    [ styles.quoteText, contenteditable True ]
                    [ text model.quote.text ]
                , div
                    [ styles.quoteAuthor, contenteditable True ]
                    [ text model.quote.author ]
                ]
            ]
        , div [ styles.editorContainer ]
            [ div [ styles.editorWrapper ]
                [ div [ styles.editorSection ]
                    [ div []
                        [ editorLabel [ text "Theme" ]
                        , div
                            [ css
                                [ displayFlex
                                ]
                            ]
                            [ themeButton model "#333333" "#FFFFFF"
                            , themeButton model "#333333" "#EDEDE9"
                            , themeButton model "#333333" "#D6CCC2"
                            , themeButton model "#333333" "#F5EBE0"
                            , themeButton model "#333333" "#E3D5CA"
                            ]
                        ]
                    ]
                , div
                    [ styles.editorSection ]
                    [ editorLabel [ text "Size" ]
                    , div [ styles.buttonGroup ]
                        [ sizeButton model 250
                        , sizeButton model 400
                        , sizeButton model 600
                        ]
                    ]
                , div
                    [ styles.editorSection ]
                    [ editorLabel [ text "Font" ]
                    , div [ styles.buttonGroup ]
                        [ fontButton model "serif"
                        , fontButton model "sans-serif"
                        , fontButton model "monospace"
                        , fontButton model "cursive"
                        ]
                    ]
                , div
                    [ styles.editorSection ]
                    [ editorLabel [ text "Alignment" ]
                    , div [ styles.buttonGroup ]
                        [ alignButton model Left
                        , alignButton model Center
                        , alignButton model Right
                        ]
                    ]
                , div
                    [ styles.editorSection ]
                    [ editorLabel
                        [ text "Export"
                        , kbd [ styles.kbd ]
                            [ text "⌘ S" ]
                        ]
                    , div [ styles.exportButton ]
                        [ text "Export"
                        ]
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
            , display inlineBlock
            , height (em 2)
            ]
        ]
        children


themeButton : Model -> String -> String -> Html Msg
themeButton model fg bg =
    let
        theme =
            model.theme
    in
    a
        [ css
            [ color (hex fg)
            , backgroundColor (hex bg)
            , displayFlex
            , justifyContent center
            , alignItems center
            , width (em 2.5)
            , height (em 2.5)
            , flexWrap noWrap
            , borderRadius (em 2.5)
            , fontSize (em 0.75)
            , margin4 (em 0) (em 0.75) (em 0.75) (em 0)
            , cursor default
            , if theme.foreground == fg && theme.background == bg then
                border3 (px 1) solid (rgba 0 0 0 0.8)

              else
                border3 (px 1) solid (rgba 0 0 0 0.2)
            , transition
                [ Transitions.boxShadow 250
                , Transitions.transform 150
                , Transitions.border 150
                ]
            , active
                [ border3 (px 1) solid (rgba 0 0 0 0.4)
                ]
            , hover
                [ boxShadow4 (px 0) (px 0) (px 5) (rgba 0 0 0 0.2)
                , transform (scale 1.15)
                ]
            ]
        , onClick
            (SetTheme
                { foreground = fg
                , background = bg
                , font =
                    theme.font
                }
            )
        ]
        [ text " Q " ]


sizeButton : Model -> Float -> Html Msg
sizeButton model size =
    let
        styles =
            stylesheet model

        isActive =
            model.size.width == size
    in
    a
        [ styles.button
        , if isActive then
            styles.activeButton

          else
            styles.button
        , onClick
            (SetSize
                { width = size
                , height = size
                }
            )
        ]
        [ text (String.fromFloat size) ]


alignButton : Model -> Align -> Html Msg
alignButton model align =
    let
        styles =
            stylesheet model

        isActive =
            model.align == align
    in
    a
        [ styles.button
        , if isActive then
            styles.activeButton

          else
            styles.button
        , onClick
            (SetAlign align)
        ]
        [ let
            width =
                Attributes.width

            height =
                Attributes.height

            fill =
                Attributes.fill
          in
          case align of
            Left ->
                svg
                    [ width "14", height "14" ]
                    [ rect [ x "0", y "4", width "14", height "1", fill "000" ] []
                    , rect [ x "0", y "8", width "14", height "1", fill "000" ] []
                    , rect [ x "0", y "12", width "11", height "1", fill "000" ] []
                    ]

            Center ->
                svg
                    [ width "14", height "14" ]
                    [ rect [ x "0", y "4", width "14", height "1", fill "000" ] []
                    , rect [ x "1.5", y "8", width "11", height "1", fill "000" ] []
                    , rect [ x "0", y "12", width "14", height "1", fill "000" ] []
                    ]

            Right ->
                svg
                    [ width "14", height "14" ]
                    [ rect [ x "0", y "4", width "14", height "1", fill "000" ] []
                    , rect [ x "0", y "8", width "14", height "1", fill "000" ] []
                    , rect [ x "3", y "12", width "11", height "1", fill "000" ] []
                    ]
        ]


fontButton : Model -> String -> Html Msg
fontButton model font =
    let
        theme =
            model.theme

        styles =
            stylesheet model

        isActive =
            model.theme.font == font
    in
    a
        [ styles.button
        , if isActive then
            styles.activeButton

          else
            styles.button
        , onClick
            (SetTheme
                { theme
                    | font = font
                }
            )
        ]
        [ text
            (case font of
                "serif" ->
                    "Serif"

                "sans-serif" ->
                    "Sans Serif"

                "monospace" ->
                    "Mono"

                "cursive" ->
                    "Cursive"

                _ ->
                    ""
            )
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

        SetAlign align ->
            { model | align = align }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view >> toUnstyled
        }
