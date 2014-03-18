
define ->
  class GraphNode
    constructor: (x, y, type) ->
      @data = {}
      @x = x
      @y = y
      @pos =
        x: x
        y: y
      @type = type

    toString: =>
      return "[" + @x + " " + @y + "]"

    isWall: =>
      return @type is 0
