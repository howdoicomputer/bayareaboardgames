module Grid exposing (..)

import Helper exposing (..)
import Color  exposing (Color)
import Html   exposing (Html)
import Html.Attributes
import List

type alias State childState =
  { children   : List childState
  , cellHeight : Float
  , numCols    : Int
  , gridWidth  : Float
  }

-- Get the size of a grid
gridSize : State childState -> Vector
gridSize state =
  let
    numChildren =
      List.length state.children

    numRows =
      numChildren // state.numCols

    gridHeight =
      state.cellHeight * (toFloat numRows)

  in
    { x = state.gridWidth
    , y = gridHeight
    }

-- Get the size of each individual cell of the grid
cellSize : State childState -> Vector
cellSize state =
  { x = state.gridWidth / (toFloat state.numCols)
  , y = state.cellHeight
  }

type Action childAction
  = ChildAction Int childAction

type alias Context =
  { viewport : Vector
  , row      : Int
  , column   : Int
  }

-- Generate the context of a cell at a given index
-- generateContext : Int -> State -> Context
generateContext index state =
  let
    column =
      index % state.numCols

    row =
      index // state.numCols

    viewport =
      cellSize state

  in
    { viewport = viewport
    , row      = row
    , column   = column
    }


-- As for the update, we would need to take the function to update the child component as input in order to use it appropriately.
-- update (childAction -> childState -> childState) -> Action childAction -> State childState -> State childState
update updateChild action state =
  case Action of
    ChildAction n childAction ->
      let
        updateN index childState =
          if n == index
          then
            updateChild childAction childState
          else
            childState
      in
        { state | children = List.indexMap updateN state.children }

-- view : (childAction -> childState -> childState -> Html) -> (Action childAction) -> State childState -> Html
view viewChild address state =
  let
    -- Get the dimensions of the grid
    gridDims : Vector
    gridDims =
      gridSize state

    -- Get the dimensions of an individual cell
    cellDims : Vector
    cellDims =
      cellSize state

    -- The CSS for the grid
    containerStyle =
      [ "position" => "absolute"
      , "top"      => "0px"
      , "left"     => "0px"
      , "width"    => toString gridDims.x ++ "px"
      , "height"   => toString gridDims.y ++ "px"
      ]

    -- Function to view an individual cell at a given index
    -- viewN : Int -> childState -> Html
    viewN index childState =
      let
        -- The left or x-position of the cell
        left =
          cellDims.x * toFloat (index % state.numCols)

        -- The top or y-position of the cell
        top =
          cellDims.y * toFloat (index // state.numCols)

        -- The CSS styles for the cell
        -- HINT: try adding a border here to see the cell
        childContainerStyle =
          [ "position" => "absolute"
          , "left"     => toString left ++ "px"
          , "top"      => toString top ++ "px"
          , "width"    => toString cellDims.y ++ "px"
          , "height"   => toString cellDims.x ++ "px"
          ]

        -- Make a forwarding address for the child at the given index
        childAddress =
          map ChildAction index

      in
        -- We simply wrap the child in a container div
        Html.div
              [ Html.Attributes.style childContainerStyle ]
              [ viewChild childAddress childState ]

  in
    -- wrap the whole thing in a div
    -- and view each child with the `viewN` function defined above
    Html.div
        [ Html.Attributes.style containerStyle ]
        ( List.indexedMap viewN state.children )
