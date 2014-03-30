
define ['render/World'], (World) ->
  class Utils
    constructor: (world) ->
      @world = world

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


    isSamePoint: (a, b) ->
      xa = a.data('x')
      ya = a.data('y')

      xb = b.data('x')
      yb = b.data('y')

      return xa is xb and ya is yb

    reversePath: (node) ->
      path = [[node.data('x'), node.data('y')]]
      while node.data('parent')
        node = node.data('parent')
        path.push([node.data('x'), node.data('y')])

      return path.reverse()

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

    cleanUp: (map) ->
      $('.map-'+map+' td').data('opened', null)
      $('.map-'+map+' td').data('closed', null)
      $('.map-'+map+' td').data('f', null)
      $('.map-'+map+' td').data('g', null)
      $('.map-'+map+' td').data('h', null)
      $('.map-'+map+' td').data('parent', null)
