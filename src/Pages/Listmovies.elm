module Pages.Listmovies exposing(..)


import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import RemoteData
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import CustomHtmlEvents exposing (onLinkClick)
import Updates exposing (update)
import Subs exposing (subscriptions)
import Msgs exposing (Msg)
import Cmds exposing (cmdListMovies)
import Routing exposing (parseLocation) 

import Types exposing (Model,Route(..),Movie,Movie_Slug)
-- import CustomHtmlEvents exposing (onLinkClick)


import Material
-- init : ( Model, Cmd Msg )
-- init =
--     (model
--         {name="Hello"
--         ,mdl= Material.model 
--         ,selectedTab = 0
--         ,posts=[]
--         }
--         ,cmdListMovies
                    
--             )

-- initialState : Location -> ( Model, Cmd Msg )
-- initialState location =
--     initialModel ! []

initialModel : Route -> Model
initialModel route =
    ({ 
        name="Hello"
        , mdl= Material.model 
        , selectedTab = 0
        , posts = RemoteData.Loading
        , route = MoviesRoute
    })


-- init : ( Model, Cmd Msg )
-- init =
--     ( initialModel, cmdListMovies )

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( initialModel currentRoute, cmdListMovies )

main : Program Never Model Msg
main =
    -- Html.program
    Navigation.program
        Msgs.UrlChange
        { init = init
        , view = my
        , update = update
        , subscriptions = subscriptions
        }


my : Model -> Html Msg
my model =
    div []
        [ mylistview model ]

mylistview : Model -> Html Msg
mylistview model =
    listview model.posts

listview : WebData (List Movie) -> Html Msg
listview response =
    Html.div []
        [ 
         maybeList response
        ]

maybeList : WebData (List Movie) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success posts ->
            movieViews posts

        RemoteData.Failure error ->
            text (toString error)




movieViews : List Movie -> Html Msg
movieViews players =
    Html.div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "TITLE" ]
                    , th [] [ text "DES" ]
                    , th [] [ text "SLUG" ]
                    
                    ]
                ]
            , tbody [] (List.map playerRow players)
            ]
        ]


playerRow : Movie -> Html Msg
playerRow player =
    tr []
        [ td [] [ text (toString player.pk) ]
        , td [] [ text player.des ]
        , td [] [ text (toString player.slug) ]
        , td []
            [ editBtn player ]
        ]


editBtn : Movie -> Html Msg
editBtn movie =
    let
        path =
            "/watch/" ++ movie.slug
    in
        a
            [ class "btn regular"
            , href path
            ]
            [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]


-- editBtn : Movie -> Html.Html Msg
-- editBtn movie =
--     let
--         path =
--             playerPath movie.slug
--     in
--         a
--             [ class "btn regular"
--             , href path
--             ]
--             [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]