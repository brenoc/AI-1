
define ['render/world', 'render/link', 'ai/astar',
        'ai/travellingSalesman'],
  (World, Link, AStar, TravellingSalesman) ->
    class Adventure
      constructor: (setup) ->
        @setup = setup
        @world = new World(setup)
        @link = new Link(setup, @world)
        @astar = new AStar(setup, @world)
        @travellingSalesman = new TravellingSalesman(setup, @astar, @world)

        @lostWoods = setup.world.lostwoods

      start: () ->
        fullPath = []
        fullCost = 0

        # Calculating combination of costs
        result = @travellingSalesman.calculateBestCost()

        # Start timer
        start = new Date().getTime()

        # First part of the path
        [fullPath, fullCost] = @worldPath(fullPath, fullCost,
                                          @setup.link,
                                          result.firstPoint)

        # First dungeon
        [fullPath, fullCost] = @dungeonPath(fullPath, fullCost,
                                            result.firstPoint)



        # Second part of the Path
        [fullPath, fullCost] = @worldPath(fullPath, fullCost,
                                          result.firstPoint,
                                          result.secondPoint)

        # Second dungeon
        [fullPath, fullCost] = @dungeonPath(fullPath, fullCost,
                                            result.secondPoint)




        # Third part of the Path
        [fullPath, fullCost] = @worldPath(fullPath, fullCost,
                                          result.secondPoint,
                                          result.thirdPoint)

        # Third dungeon
        [fullPath, fullCost] = @dungeonPath(fullPath, fullCost,
                                            result.thirdPoint)




        # Lost Woods
        [fullPath, fullCost] = @worldPath(fullPath, fullCost,
                                          result.thirdPoint,
                                          @lostWoods)

        end = new Date().getTime()
        time = end - start

        # Makes Link walk
        @moveAlongThePath(fullPath)

        # Return the time and cost
        info =
          time: time
          cost: fullCost

        return info

      worldPath: (fullPath, fullCost, point, destination) =>
        computed = @astar.findPath  'world',
                                    point.x,
                                    point.y,
                                    destination.x,
                                    destination.y

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        fullCost += computed.cost
        fullPath = fullPath.concat(computed.path)

        return [fullPath, fullCost]

      dungeonPath: (fullPath, fullCost, dungeonEntrance) =>

        dungeon = @world.getPositionSelector dungeonEntrance.x,
                                             dungeonEntrance.y,
                                             'world'

        dungeon = 'dungeon' + dungeon.data('dungeon')
        pendant = @setup.dungeons[dungeon].pendant
        door = @setup.dungeons[dungeon].door
        computed = @astar.findPath  dungeon,
                                    door.x,
                                    door.y,
                                    pendant.x,
                                    pendant.y
        @world.gridEverything()

        fullPath.push('enter')
        fullCost += computed.cost
        fullPath = fullPath.concat(computed.path)

        # Get the pendant
        fullPath.push('getPendant')

        # Walk Back to the Door
        fullCost += computed.cost
        fullPath = fullPath.concat(computed.path.reverse())

        # Leaves Dungeon
        fullPath.push('leave')

        return [fullPath, fullCost]

      moveAlongThePath: (path) =>
        for movement, i in path
          setTimeout do (movement) =>
            =>
              if movement is 'enter'
                @link.enter()
              else if movement is 'leave'
                @link.leave()
              else if movement is 'getPendant'
                @link.getPendant()
              else if movement[0] > @link.position.x
                @link.moveRight()
              else if movement[0] < @link.position.x
                @link.moveLeft()
              else if movement[1] > @link.position.y
                @link.moveDown()
              else if movement[1] < @link.position.y
                @link.moveUp()
          , (i*@setup.speed)


