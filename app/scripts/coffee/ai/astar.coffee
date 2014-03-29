
define ['structure/Heap', 'ai/Utils'], (Heap, Utils) ->
  class AStar
    constructor: (setup, world) ->
      @utils = new Utils(world)
      @world = world

    findPath: (map, x0, y0, xf, yf) ->
      # Create a custom comparison function
      openList = new Heap (a,b) ->
        return $(a).data('f') - $(b).data('f')

      startNode = @world.getPositionSelector(x0, x0)
      endNode = @world.getPositionSelector(xf, yf)
      #abs = Math.abs, SQRT2 = Math.SQRT2,

      $(startNode).data('g', 0)
      $(startNode).data('f', 0)

      openList.push(startNode)
      $(startNode).data('opened', true)

      while not openList.empty()

        node = openList.pop()
        $(node).data('closed', true)

        if @utils.isSamePoint(node, endNode)
          return @utils.reversePath(endNode)

        neighbors = @utils.getNeighbors(map, node)
        for neighbor in neighbors
          console.log 'a'
