
define ['render/World'], (World) ->
  class Utils
    constructor: (world) ->
      @world = world

    isWalkable: (map, node) =>
      x = $(node).data('x')
      y = $(node).data('y')

      position = @world.getPositionSelector(x, y, map)

      if position.length > 0
        cost = $(position).data('cost')

        if cost is Infinity
          return false
        else
          return true
      else
        return false


    isSamePoint: (a, b) ->
      xa = $(a).data('x')
      ya = $(a).data('y')

      xb = $(b).data('x')
      yb = $(a).data('y')

      return xa is xb and ya is yb

    reversePath: (node) ->
      console.warn('TODO')

    getNeighbors: (map, node) =>
      x = $(node).data('x')
      y = $(node).data('y')

      up = @world.getPositionSelector(x, y-1, map)
      down = @world.getPositionSelector(x, y+1, map)
      left = @world.getPositionSelector(x-1, y, map)
      right = @world.getPositionSelector(x+1, y, map)

      candidates = [up, down, left, right]

      return _.filter candidates, (p) =>
        return @isWalkable(map, p)
