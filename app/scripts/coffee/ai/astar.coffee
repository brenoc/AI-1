
define ['structure/Heap', 'ai/Utils'], (Heap, Utils) ->
  class AStar
    constructor: (setup, world) ->
      @utils = new Utils(world)
      @world = world

    # Manhattan
    h: (a, b) ->
      d1 = Math.abs(b.x - a.x)
      d2 = Math.abs(b.y - a.y)
      return d1 + d2

    # AStar Algorithm
    # map - name of the map ('world', 'dungeon1', etc)
    # x0, y0 - start point
    # xf, yf - final point
    findPath: (map, x0, y0, xf, yf) ->

      # Create a custom comparison function
      openList = new Heap (a,b) ->
        return a.f - b.f

      startNode = @world.getNode(x0, y0, map)
      endNode = @world.getNode(xf, yf, map)

      startNode.g = 0
      startNode.f = 0
      startNode.opened = true

      openList.push(startNode)

      while not openList.empty()
        node = openList.pop()
        node.closed = true

        # In this case we arrived to the final destination
        if node.x is endNode.x and node.y is endNode.y
          path = @utils.reversePath(endNode)

          result =
            path: path
            cost: node.f
          return result


        neighbors = @utils.getNeighbors(map, node)
        for neighbor in neighbors
          if neighbor.closed then continue

          # Calculate g
          ng = node.g + neighbor.cost

          beenVisited = neighbor.opened

          if not beenVisited or ng < neighbor.g
            neighbor.opened = true
            neighbor.g = ng

            if not neighbor.h
              # Calculate h
              neighbor.h = @h(neighbor, endNode)

            # Calculate f
            neighbor.f = ng + neighbor.h
            neighbor.parent = node

            if not beenVisited
              openList.push(neighbor)
            else
              openList.updateItem(neighbor)

      # Couldn't find a path
      return []
