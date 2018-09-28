import Array
import Browser
import Html exposing (Html, button, div, text, img)
import Html.Attributes exposing (src, width, height)
import Html.Events exposing (onClick)

main =
  Browser.sandbox { init = init, update = update, view = view }


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

currImage : (Int, List String) -> Html Msg
currImage (current, images) =
  let curr = Array.get current (Array.fromList images) in
    case curr of
      Just imgSrc -> img [ src imgSrc, width 600, height 400 ] []
      Nothing -> img [] []

view : Model -> Html Msg
view model =
  div []
    [ currImage (model.current, model.images)
    , button [ onClick Left ] [ text "left" ]
    , button [ onClick Right ] [ text "right" ]
    , div [] [ text (String.fromInt model.current) ]
    ]