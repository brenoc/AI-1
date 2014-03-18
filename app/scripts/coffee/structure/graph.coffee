
define ['structure/node'], (GraphNode) ->
  class Graph
    constructor: (grid) ->
      nodes = []
      x = 0

      while x < grid.length
        nodes[x] = []
        y = 0
        row = grid[x]

        while y < row.length
          nodes[x][y] = new GraphNode(x, y, row[y])
          y++
        x++
      @input = grid
      @nodes = nodes

    toString = =>
      graphString = "\n"
      nodes = @nodes
      rowDebug = undefined
      row = undefined
      y = undefined
      l = undefined
      x = 0
      len = nodes.length

      while x < len
        rowDebug = ""
        row = nodes[x]
        y = 0
        l = row.length

        while y < l
          rowDebug += row[y].type + " "
          y++
        graphString = graphString + rowDebug + "\n"
        x++
      graphString
