
define ['structure/Heap', 'ai/Utils'], (Heap, Utils) ->
  class AStar
    constructor: (setup, world) ->
      @utils = new Utils(world)
      @world = world

    h: (a, b) ->
      d1 = Math.abs(b.data('x') - a.data('x'))
      d2 = Math.abs(b.data('y') - a.data('y'))
      return d1 + d2

    findPath: (map, x0, y0, xf, yf) ->
      # Create a custom comparison function
      openList = new Heap (a,b) ->
        return a.data('f') - b.data('f')

      startNode = @world.getPositionSelector(x0, y0, map)
      endNode = @world.getPositionSelector(xf, yf, map)

      startNode.data('g', 0)
      startNode.data('f', 0)
      startNode.data('opened', true)

      openList.push(startNode)

      while not openList.empty()

        node = openList.pop()
        node.data('closed', true)
        ndx = node.data('x')
        ndy = node.data('y')


        if @utils.isSamePoint(node, endNode)
          path = @utils.reversePath(endNode)

          result =
            path: path
            cost: node.data('f')

          return result


        neighbors = @utils.getNeighbors(map, node)

        for neighbor in neighbors

          if neighbor.data('closed') then continue

          nbx = neighbor.data('x')
          nby = neighbor.data('y')

          # Calculate g
          ng = node.data('g') + neighbor.data('cost')

          beenVisited = neighbor.data('opened')

          if not beenVisited or ng < neighbor.data('g')

            neighbor.data('opened', true)
            neighbor.data('g', ng)

            if not neighbor.data('h')
              # Calculate h
              neighbor.data('h', @h(neighbor, endNode))

            # Calculate f
            neighbor.data('f', ng + neighbor.data('h'))
            neighbor.data('parent', node)

            if not beenVisited
              openList.push(neighbor)
            else
              openList.updateItem(neighbor)

      return []
