
define ['render/World'], (World) ->
  class Utils
    constructor: (world) ->
      @world = world

    # Check if node is part of the map or it doesn't have Infinity cost
    isWalkable: (node) ->
      return node.cost isnt Infinity

    # Returns the path from start to finish as an array of coordinates
    # Like so: [[x0,y0],[x1,y1],...,[xf,yf]]
    reversePath: (node) ->
      path = [[node.x, node.y]]
      while node.parent
        node = node.parent
        path.push([node.x, node.y])

      return path.reverse()

    # Get walkable neighbors from the node
    getNeighbors: (map, node) =>
      x = node.x
      y = node.y

      up = @world.getNode(x, y-1, map)
      down = @world.getNode(x, y+1, map)
      left = @world.getNode(x-1, y, map)
      right = @world.getNode(x+1, y, map)

      candidates = [up, down, left, right]

      return _.filter candidates, (p) =>
        return p and @isWalkable(p)
