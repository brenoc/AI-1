
define ['structure/node'], (Node) ->
  class Grid
    constructor: (map) ->
      grid = []
      for rowM, y in map
        currentRow = []
        for colM, x in rowM
          node = new Node(x, y, colM)
          currentRow.push(node)
        grid.push(currentRow)

      return grid

