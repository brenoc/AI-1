
define ['render/world', 'render/link', 'ai/astar'],
  (World, Link, AStar) ->
    class Adventure
      constructor: (setup) ->
        @setup = setup
        @world = new World(setup)
        @link = new Link(setup, @world)
        @astar = new AStar(setup, @world)

      start: () ->
        # Example of usage:

        # Give the algorithm some destination
        # x, y point of destiny and name of the map
        destination =
          x: 30
          y: 2
          map: 'world'

        # Start timer
        start = new Date().getTime()
        # Call the AStar algorithm
        result = @astar.findPath  destination.map,
                                  @setup.link.x,
                                  @setup.link.y,
                                  destination.x,
                                  destination.y
        # End timer
        end = new Date().getTime()
        time = end - start

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(result.path)

        # Return the time and cost
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
