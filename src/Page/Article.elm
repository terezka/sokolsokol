module Page.Article exposing (Model, Msg, init, update, view)

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Page.Skeleton as Skeleton
import Session


type alias Model =
    { session : Session.Data }


init : Session.Data -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


type Msg
    = Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Skeleton.Document Msg
view model =
    { title = "SOKOL SOKOL | Kafka, Civilization, and Bureaucracy"
    , body =
        [ Html.article
            [ Attr.css [ Css.maxWidth (Css.px 780), Css.property "column-count" "2" ] ]
            [ Html.img [ Attr.src "https://spectrum.ieee.org/image/Mjc5MDM4Nw.jpeg", Attr.css [ Css.width (Css.pct 100) ] ] []
            , Html.h1 [ Attr.css [ Css.textDecoration Css.overline ] ] [ Html.text "Kafka, Civilization, and Bureaucracy" ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.p [] [ Html.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer et fermentum massa. Proin rutrum suscipit finibus. Sed consequat, est at blandit accumsan, neque turpis gravida nulla, ac cursus arcu lorem a eros. Integer purus libero, imperdiet ac ligula quis, porttitor mattis leo. Vivamus laoreet elit at ante iaculis fringilla. Mauris nec imperdiet magna. Maecenas finibus urna in ex sodales, vitae porta turpis scelerisque." ]
            , Html.i [] [ Html.text "By Tereza Sokol" ]
            ]
        ]
    }
