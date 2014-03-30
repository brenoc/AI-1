
define ['render/world', 'render/link', 'ai/astar'],
  (World, Link, AStar) ->
    class Adventure
      constructor: (setup) ->
        @setup = setup
        @world = new World(setup)
        @link = new Link(setup, @world)
        @astar = new AStar(setup, @world)

      start: () ->
        destination =
          x: 30
          y: 2
          map: 'world'

        start = new Date().getTime()
        result = @astar.findPath  destination.map,
                                  @setup.link.x,
                                  @setup.link.y,
                                  destination.x,
                                  destination.y
        end = new Date().getTime()
        time = end - start

        @astar.utils.cleanUp(destination.map)
        @moveAlongThePath(result.path)

        info =
          time: time
          cost: result.cost

        return info

      moveAlongThePath: (path) =>
        for movement, i in path
          setTimeout do (movement) =>
            =>
              if movement[0] > @link.position.x
                @link.moveRight()
              else if movement[0] < @link.position.x
                @link.moveLeft()
              else if movement[1] > @link.position.y
                @link.moveDown()
              else if movement[1] < @link.position.y
                @link.moveUp()
          , (i*50)
