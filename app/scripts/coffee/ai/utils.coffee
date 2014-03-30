
define ['render/World'], (World) ->
  class Utils
    constructor: (world) ->
      @world = world

    # Check if node is part of the map or it doesn't have Infinity cost
    isWalkable: (map, node) =>
      x = node.data('x')
      y = node.data('y')

      position = @world.getPositionSelector(x, y, map)

      if position.length > 0
        cost = position.data('cost')

        if cost is Infinity
          return false
        else
          return true
      else
        return false

    # Check if a is the same point as b
    isSamePoint: (a, b) ->
      xa = a.data('x')
      ya = a.data('y')

      xb = b.data('x')
      yb = b.data('y')

      return xa is xb and ya is yb

    # Returns the path from start to finish as an array of coordinates
    # Like so: [[x0,y0],[x1,y1],...,[xf,yf]]
    reversePath: (node) ->
      path = [[node.data('x'), node.data('y')]]
      while node.data('parent')
        node = node.data('parent')
        path.push([node.data('x'), node.data('y')])

      return path.reverse()

    # Get walkable neighbors from the node
    getNeighbors: (map, node) =>
      x = node.data('x')
      y = node.data('y')

      up = @world.getPositionSelector(x, y-1, map)
      down = @world.getPositionSelector(x, y+1, map)
      left = @world.getPositionSelector(x-1, y, map)
      right = @world.getPositionSelector(x+1, y, map)

      candidates = [up, down, left, right]

      return _.filter candidates, (p) =>
        return @isWalkable(map, p)

    # Clean all the data given to the nodes during the AStar algorithm
    # You MUST call this function after calling the AStar algorithm
    cleanUp: (map) ->
      $('.map-'+map+' td').data('opened', null)
      $('.map-'+map+' td').data('closed', null)
      $('.map-'+map+' td').data('f', null)
      $('.map-'+map+' td').data('g', null)
      $('.map-'+map+' td').data('h', null)
      $('.map-'+map+' td').data('parent', null)
