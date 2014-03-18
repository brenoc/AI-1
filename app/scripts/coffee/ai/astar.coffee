
define ['structure/Graph', 'structure/binaryHeap'], (Graph, BinaryHeap) ->
  class AStar
    init: (grid) ->
      x = 0
      xl = grid.length

      while x < xl
        y = 0
        yl = grid[x].length

        while y < yl
          node = grid[x][y]
          node.f = 0
          node.g = 0
          node.h = 0
          node.cost = node.type
          node.visited = false
          node.closed = false
          node.parent = null
          y++
        x++
      return

    heap: ->
      new BinaryHeap((node) ->
        node.f
      )


    # astar.search
    # supported options:
    # {
    #   heuristic: heuristic function to use
    #   diagonal: boolean specifying whether diagonal moves are allowed
    #   closest: boolean specifying whether to return closest node if
    #            target is unreachable
    # }
    search: (grid, start, end, options) ->

      # set the start node to be the closest if required
      pathTo = (node) ->
        curr = node
        path = []
        while curr.parent
          path.push curr
          curr = curr.parent
        path.reverse()
      astar.init grid
      options = options or {}
      heuristic = options.heuristic or astar.manhattan
      diagonal = !!options.diagonal
      closest = options.closest or false
      openHeap = astar.heap()
      closestNode = start
      start.h = heuristic(start.pos, end.pos)
      openHeap.push start
      while openHeap.size() > 0

        # Grab the lowest f(x) to process next.  Heap keeps this sorted for us.
        currentNode = openHeap.pop()

        # End case -- result has been found, return the traced path.
        return pathTo(currentNode)  if currentNode is end

        # Normal case -- move currentNode from open to closed, process each of
        # its neighbors.
        currentNode.closed = true

        # Find all neighbors for the current node. Optionally find diagonal
        # neighbors as well (false by default).
        neighbors = astar.neighbors(grid, currentNode, diagonal)
        i = 0
        il = neighbors.length

        while i < il
          neighbor = neighbors[i]

          # Not a valid node to process, skip to next neighbor.
          continue  if neighbor.closed or neighbor.isWall()

          # The g score is the shortest distance from start to current node.
          # We need to check if the path we have arrived at this neighbor is the
          # shortest one we have seen yet.
          gScore = currentNode.g + neighbor.cost
          beenVisited = neighbor.visited
          if not beenVisited or gScore < neighbor.g

            # Found an optimal (so far) path to this node.  Take score for node
            # to see how good it is.
            neighbor.visited = true
            neighbor.parent = currentNode
            neighbor.h = neighbor.h or heuristic(neighbor.pos, end.pos)
            neighbor.g = gScore
            neighbor.f = neighbor.g + neighbor.h

            # If the neighbour is closer than the current closestNode or if it's
            # equally close but has a cheaper path than the current closest node
            # then it becomes the closest node
            if closest
              if neighbor.h < closestNode.h or
                  (neighbor.h is closestNode.h and neighbor.g < closestNode.g)
                closestNode = neighbor

            if not beenVisited
              # Pushing to heap will put it in proper place based on the 'f'
              # value.
              openHeap.push neighbor
            else

              # Already seen the node, but since it has been rescored we need to
              # reorder it in the heap
              openHeap.rescoreElement neighbor
          i++
      return pathTo(closestNode)  if closest

      # No result was found - empty array signifies failure to find path.
      []

    manhattan: (pos0, pos1) ->

      # See list of heuristics:
      # http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html
      d1 = Math.abs(pos1.x - pos0.x)
      d2 = Math.abs(pos1.y - pos0.y)
      d1 + d2

    diagonal: (pos0, pos1) ->
      D = 1
      D2 = Math.sqrt(2)
      d1 = Math.abs(pos1.x - pos0.x)
      d2 = Math.abs(pos1.y - pos0.y)
      (D * (d1 + d2)) + ((D2 - (2 * D)) * Math.min(d1, d2))

    neighbors: (grid, node, diagonals) ->
      ret = []
      x = node.x
      y = node.y

      # West
      ret.push grid[x - 1][y]  if grid[x - 1] and grid[x - 1][y]

      # East
      ret.push grid[x + 1][y]  if grid[x + 1] and grid[x + 1][y]

      # South
      ret.push grid[x][y - 1]  if grid[x] and grid[x][y - 1]

      # North
      ret.push grid[x][y + 1]  if grid[x] and grid[x][y + 1]
      if diagonals

        # Southwest
        ret.push grid[x - 1][y - 1]  if grid[x - 1] and grid[x - 1][y - 1]

        # Southeast
        ret.push grid[x + 1][y - 1]  if grid[x + 1] and grid[x + 1][y - 1]

        # Northwest
        ret.push grid[x - 1][y + 1]  if grid[x - 1] and grid[x - 1][y + 1]

        # Northeast
        ret.push grid[x + 1][y + 1]  if grid[x + 1] and grid[x + 1][y + 1]
      ret
