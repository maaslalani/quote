port module Main exposing (desktop, main)

import Browser
import Browser.Events exposing (onKeyDown, onKeyPress, onKeyUp)
import Css exposing (..)
import Css.Media exposing (withMediaQuery)
import Css.Transitions as Transitions exposing (transition)
import Html.Styled exposing (Attribute, Html, a, div, kbd, label, text, toUnstyled)
import Html.Styled.Attributes exposing (contenteditable, css, id)
import Html.Styled.Events exposing (onClick)
import Json.Decode as Decode
import Quote exposing (Quote, randomQuote, defaultQuote)
import Svg.Styled exposing (rect, svg)
import Svg.Styled.Attributes as Attributes exposing (x, y)
import VirtualDom exposing (Node)
import Svg.Styled exposing (path)
import Svg.Styled.Attributes exposing (d)
svgViewBox = Svg.Styled.Attributes.viewBox


-- Ports


port exportImage : () -> Cmd msg



-- Types


type alias Theme =
    { foreground : String
    , background : String
    }


type alias Font =
    String


type alias Size =
    { width : Float
    , height : Float
    }


type Align
    = Left
    | Center
    | Right


type alias Model =
    { align : Align
    , font : Font
    , size : Size
    , theme : Theme
    , quote : Quote
    , meta : Bool
    }


type Msg
    = SetTheme Theme
    | SetQuote Quote
    | SetFont Font
    | SetAlign Align
    | SetSize Size
    | KeyUp String
    | KeyDown String
    | KeyPress String
    | ExportImage
    | RandomQuote


themes : List Theme
themes =
    [ { foreground = "#333333", background = "#FFFFFF" }
    , { foreground = "#463f3a", background = "#d6ccc2" }
    , { foreground = "#5e503f", background = "#f5ebe0" }
    , { foreground = "#8a817c", background = "#e3d5ca" }
    , { foreground = "#ffffff", background = "#d5bdaf" }
    ]



-- Styles


desktop : List Style -> Style
desktop =
    withMediaQuery [ "screen and (min-width: 801px)" ]


mobile : List Style -> Style
mobile =
    withMediaQuery [ "screen and (max-width: 800px)" ]


stylesheet :
    Model
    ->
        { container : Attribute msg
        , quoteContainer : Attribute msg
        , quoteMask : Attribute msg
        , quoteWrapper : Attribute msg
        , quoteText : Attribute msg
        , quoteAuthor : Attribute msg
        , editorContainer : Attribute msg
        , editorWrapper : Attribute msg
        , editorSection : Attribute msg
        , buttonGroup : Attribute msg
        , button : Attribute msg
        , activeButton : Attribute msg
        , exportButton : Attribute msg
        , iconButton: Attribute msg
        , kbd : Attribute msg
        }
stylesheet model =
    { container =
        css
            [ displayFlex
            , alignItems center
            , flexDirection column
            , height (vh 100)
            , fontFamily sansSerif
            ]
    , quoteContainer =
        css
            [ desktop [ flex (int 3) ]
            , flex (int 1)
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
    , quoteMask =
        css
            [ borderRadius (px 16)
            , overflow hidden
            , border3 (px 1) solid (hex "e7ebee")
            , boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)
            ]
    , quoteWrapper =
        css
            [ fontFamilies [ model.font ]
            , height (px model.size.height)
            , width (px model.size.width)
            , backgroundColor (hex model.theme.background)
            , color (hex model.theme.foreground)
            , displayFlex
            , flexDirection column
            , justifyContent center
            , margin auto
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
            , marginBottom (em 1)
            ]
    , editorWrapper =
        css
            [ withMediaQuery [ "screen and (min-width: 800px)" ] [ display inlineFlex ]
            , backgroundColor (hex "fff")
            , boxShadow4 (px 0) (px 0) (px 20) (rgba 0 0 0 0.1)
            , padding2 (em 1) (em 1.5)
            , paddingBottom (em 2)
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
            , padding2 (px 5) (px 2)
            , display inlineFlex
            , justifyContent center
            , alignItems center
            , borderRadius (px 7)
            ]
    , button =
        css
            [ backgroundColor (hex "f4f4f5")
            , color (hex "83838b")
            , padding2 (px 5) (px 10)
            , borderRadius (px 5)
            , margin2 (em 0) (px 5)
            , whiteSpace noWrap
            , fontSize (px 12)
            , height (px 18)
            , displayFlex
            , alignItems center
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
            , height (em 1.6)
            , desktop [ height (em 1.4) ]
            , borderRadius (px 6)
            , display inlineFlex
            , alignItems center
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
    , iconButton = 
        css
            [ backgroundColor (hex "f4f4f5")
            , color (hex "83838b")
            , padding (em 1)
            , marginLeft (em 0.3)
            , borderRadius (px 5)
            , fontSize (px 12)
            , height (px 18)
            , width (px 18)
            , display inlineFlex
            , alignItems center
            , justifyContent center
            , cursor pointer
            , transition
                [ Transitions.backgroundColor 250
                ]
            , hover
                [ color (hex "1e1e20")
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



-- Model


init : () -> ( Model, Cmd Msg )
init _ =
    ( { quote = { text = "", author = "" }
      , theme =
            { foreground = "#333333"
            , background = "#FFFFFF"
            }
      , font = "serif"
      , size =
            { width = 400
            , height = 400
            }
      , align = Left
      , meta = False
      }
    , randomQuote SetQuote
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuote quote ->
            ( { model | quote = quote }, Cmd.none )

        SetTheme theme ->
            ( { model | theme = theme }, Cmd.none )

        SetFont font ->
            ( { model | font = font }, Cmd.none )

        SetSize size ->
            ( { model | size = size }, Cmd.none )

        SetAlign align ->
            ( { model | align = align }, Cmd.none )

        ExportImage ->
            ( model, exportImage () )
        
        RandomQuote ->
            ( model, randomQuote (SetQuote) )

        KeyUp key ->
            case key of
                "Meta" ->
                    ( { model | meta = False }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        KeyDown key ->
            case key of
                "Meta" ->
                    ( { model | meta = True }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        KeyPress key ->
            case key of
                "e" ->
                    if model.meta then
                        ( model, exportImage () )

                    else
                        ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )


view : Model -> { title : String, body : List (Node Msg) }
view model =
    let
        styles =
            stylesheet model
    in
    { title = "Quote"
    , body =
        [ toUnstyled
            (div
                [ styles.container ]
                [ div [ styles.quoteContainer ]
                    [ div [ styles.quoteMask ]
                        [ div
                            [ id "quote", styles.quoteWrapper ]
                            [ div
                                [ styles.quoteText, contenteditable True ]
                                [ text model.quote.text ]
                            , div
                                [ styles.quoteAuthor, contenteditable True ]
                                [ text model.quote.author ]
                            ]
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
                                    (List.map
                                        (\theme -> themeButton model theme)
                                        themes
                                    )
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
                                    [ text "⌘ E" ]
                                ]
                            , a [ styles.exportButton, onClick ExportImage ]
                                [ text "Export"
                                ]
                            , a [ styles.iconButton, onClick RandomQuote ]
                                [ resetIcon
                                ]
                            , a [ styles.iconButton, onClick (SetQuote defaultQuote) ]
                                [ reloadIcon
                                ]
                            ]
                        ]
                    ]
                ]
            )
        ]
    }



-- Components


editorLabel : List (Html msg) -> Html msg
editorLabel children =
    label
        [ css
            [ fontSize (em 0.8)
            , color (hex "635852")
            , display block
            , marginTop (em 1.25)
            , marginBottom (em 1)
            ]
        ]
        children


themeButton : Model -> Theme -> Html Msg
themeButton model theme =
    a
        [ css
            [ color (hex theme.foreground)
            , backgroundColor (hex theme.background)
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
            , if
                theme.foreground
                    == model.theme.foreground
                    && theme.background
                    == model.theme.background
              then
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
            (SetTheme theme)
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

        style =
            if isActive then
                styles.activeButton

            else
                styles.button
    in
    a
        [ styles.button, style, onClick (SetAlign align) ]
        [ alignIcon align ]


alignIcon : Align -> Html msg
alignIcon align =
    let
        width =
            Attributes.width

        height =
            Attributes.height
    in
    svg
        [ width "14", height "14" ]
        [ rect [ y "2", width "14", height "1" ] []
        , rect
            [ y "6"
            , height "1"
            , width (ternary (align == Center) "10" "14")
            , x (ternary (align == Center) "2" "0")
            ]
            []
        , rect
            [ y "10"
            , height "1"
            , x (ternary (align == Right) "4" "0")
            , width (ternary (align == Center) "14" "10")
            ]
            []
        ]


resetIcon : Html Msg
resetIcon = 
    let
        width =
            Attributes.width

        height =
            Attributes.height
    in
    svg
    [ width "16", height "14", svgViewBox "0 0 448 512" ]
    [ path [ d "M64 48C37.5 48 16 69.5 16 96V416c0 26.5 21.5 48 48 48H384c26.5 0 48-21.5 48-48V96c0-26.5-21.5-48-48-48H64zM0 96C0 60.7 28.7 32 64 32H384c35.3 0 64 28.7 64 64V416c0 35.3-28.7 64-64 64H64c-35.3 0-64-28.7-64-64V96zm144 64a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm-48 0a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zM224 272a16 16 0 1 0 0-32 16 16 0 1 0 0 32zm0-48a32 32 0 1 1 0 64 32 32 0 1 1 0-64zM336 352a16 16 0 1 0 -32 0 16 16 0 1 0 32 0zm-48 0a32 32 0 1 1 64 0 32 32 0 1 1 -64 0z"] [] ]

reloadIcon : Html Msg
reloadIcon = 
    let
        width =
            Attributes.width

        height =
            Attributes.height
    in
    svg
    [ width "16", height "14", svgViewBox "0 0 448 512" ]
    [ path [ d "M386.3 160H336c-17.7 0-32 14.3-32 32s14.3 32 32 32H464c17.7 0 32-14.3 32-32V64c0-17.7-14.3-32-32-32s-32 14.3-32 32v51.2L414.4 97.6c-87.5-87.5-229.3-87.5-316.8 0s-87.5 229.3 0 316.8s229.3 87.5 316.8 0c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0c-62.5 62.5-163.8 62.5-226.3 0s-62.5-163.8 0-226.3s163.8-62.5 226.3 0L386.3 160z"] [] ]


ternary : Bool -> a -> a -> a
ternary condition consequent alternate =
    if condition then
        consequent

    else
        alternate


fontButton : Model -> String -> Html Msg
fontButton model font =
    let
        styles =
            stylesheet model

        isActive =
            model.font == font
    in
    a
        [ styles.button
        , css [ fontFamilies [ font ] ]
        , if isActive then
            styles.activeButton

          else
            styles.button
        , onClick (SetFont font)
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


keyUpDecoder : Decode.Decoder Msg
keyUpDecoder =
    Decode.map KeyUp (Decode.field "key" Decode.string)


keyPressDecoder : Decode.Decoder Msg
keyPressDecoder =
    Decode.map KeyPress (Decode.field "key" Decode.string)


keyDownDecoder : Decode.Decoder Msg
keyDownDecoder =
    Decode.map KeyDown (Decode.field "key" Decode.string)


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onKeyDown keyDownDecoder
        , onKeyUp keyUpDecoder
        , onKeyPress keyPressDecoder
        ]



-- Main


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
