import Array
import Browser
import Css exposing (..)
import Css.Global exposing (Snippet, global)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick)

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view >> toUnstyled }


-- MODEL

type alias Model =
  { images : List String
  , current: Int
  }

init : Model
init =
  { images = ["./img/1.jpg", "./img/2.jpg", "./img/3.jpg"]
  , current = 0
  }


-- UPDATE

type Msg = Left | Right

update : Msg -> Model -> Model
update msg model =
  case msg of
    Left ->
      { model
        | images = model.images
        , current =
          let imgLen = List.length model.images in
            if model.current == 0 then imgLen - 1 else model.current - 1
      }

    Right ->
      { model
        | images = model.images
        , current =
          let imgLen = List.length model.images in
            if model.current < imgLen - 1 then model.current + 1 else 0
      }


-- VIEW

image : String -> Html msg
image source =
    img [ src source
      , css [ width (pct 100), height (px 600) ] ]
    []

currImage : (Int, List String) -> Html Msg
currImage (current, images) =
  case Array.get current <| Array.fromList images of
    Just imgSrc -> image imgSrc
    Nothing -> img [] []

cursorBtn : List Style -> Html Msg
cursorBtn styles =
  div [
    onClick Left
    , css <| [
      position absolute
      , width (pct 50)
      , height (px 600)
      , top (px 0)
      , cursor wResize
    ] ++ styles
  ] []

leftBtn : Html Msg
leftBtn = cursorBtn [ left (px 0), cursor wResize ]

rightBtn : Html Msg
rightBtn = cursorBtn [ right (px 0), cursor eResize ]

body : List (Attribute msg) -> List (Html msg) -> Html msg
body attributes children =
  styled div [] attributes (global
    [ Css.Global.html [ margin (px 0) ]
    , Css.Global.body [ margin (px 0) ]
    ] :: children)

view : Model -> Html Msg
view model =
  body [] [ currImage (model.current, model.images)
    , leftBtn
    , rightBtn
    , div [] [ text (String.fromInt model.current) ]
  ]