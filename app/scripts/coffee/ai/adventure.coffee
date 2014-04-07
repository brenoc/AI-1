
define ['render/world', 'render/link', 'ai/astar'],
  (World, Link, AStar) ->
    class Adventure
      constructor: (setup) ->
        @setup = setup
        @world = new World(setup)
        @link = new Link(setup, @world)
        @astar = new AStar(setup, @world)
        @dungeonOne = setup.world.dungeon1
        @dungeonTwo = setup.world.dungeon2
        @dungeonThree = setup.world.dungeon3
        @lostWoods = setup.world.lostwoods

      start: () ->
        # Start timer
        #start = new Date().getTime()

        # Calculating combination of costs
        result = @CalculateBestCost()

        # End timer
        end = new Date().getTime()
        time = end - start

        # Calling the algorithm to get the path of each step of the route
        firstPath = @astar.findPath  'world',
                                  @setup.link.x,
                                  @setup.link.y,
                                  result.firstPoint.x,
                                  result.firstPoint.y

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(firstPath.path)

        # Makes Link Enter Dungeon
        @link.enter()

        # Walk to the pendant
        # TODO

        # Walk Back to the Door
        # TODO

        # Leaves Dungeon
        @link.leave()

        # Second part of the Path
        secondPath = @astar.findPath  'world',
                                  result.firstPoint.x,
                                  result.firstPoint.y,
                                  result.secondPoint.x,
                                  result.secondPoint.y

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(secondPath.path)

        # Makes Link Enter Dungeon
        @link.enter()

        # Walk to the pendant
        # TODO

        # Walk Back to the Door
        # TODO

        # Leaves Dungeon
        @link.leave()

        # Third part of the Path
        thirdPath = @astar.findPath  'world',
                                  result.secondPoint.x,
                                  result.secondPoint.y,
                                  result.thirdPoint.x,
                                  result.thirdPoint.y

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(thirdPath.path)

        # Makes Link Enter Dungeon
        @link.enter()

        # Walk to the pendant
        # TODO

        # Walk Back to the Door
        # TODO

        # Leaves Dungeon
        @link.leave()

        # Forth part of the Path
        forfthPath = @astar.findPath  'world',
                                  result.thirdPoint.x,
                                  result.thirdPoint.y,
                                  @lostWoods.x,
                                  @lostWoods.y

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(forfthPath.path)

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

      CalculateFullCost: (map, startPoint, firstStop,
                                secondStop, thirdStop,
                                endPoint) =>

        result = @astar.findPath  map,
                                  startPoint.x,
                                  startPoint.y,
                                  firstStop.x,
                                  firstStop.y

        #First Path cost
        fullCost = result.cost
        @world.gridEverything()

        #Second Path Cost
        result = @astar.findPath  map,
                                  firstStop.x,
                                  firstStop.y,
                                  secondStop.x,
                                  secondStop.y

        fullCost = fullCost + result.cost
        @world.gridEverything()

        #Third Path Cost
        result = @astar.findPath  map,
                                  secondStop.x,
                                  secondStop.y,
                                  thirdStop.x,
                                  thirdStop.y

        fullCost = fullCost + result.cost
        @world.gridEverything()

        # Forth Path Cost
        result = @astar.findPath  map,
                                  thirdStop.x,
                                  thirdStop.y,
                                  endPoint.x,
                                  endPoint.y

        fullCost = fullCost + result.cost
        @world.gridEverything()

        return fullCost

        #Class to Map Cost + Steps Order
      class CostsMapper
        constructor : (@cost, @firstPoint, @secondPoint, @thirdPoint) ->

       #Possible Combinations
       # START,D1,D2,D3,DW
       # START,D1,D3,D2,DW
       # START,D2,D1,D3,DW
       # START,D2,D3,D1,DW
       # START,D3,D2,D1,DW
       # START,D3,D1,D2,DW
       CalculateBestCost: =>

        # First Path Cost
        pathCost = @CalculateFullCost  'world', @setup.link,
                                                  @dungeonOne, @dungeonTwo,
                                                  @dungeonThree, @lostWoods

        costsMapper = new CostsMapper(pathCost,
                                                            @dungeonOne,
                                                            @dungeonTwo,
                                                            @dungeonThree)

        # Array Mapping costs with it's respective path
        costsArray = [costsMapper]

        # Second Path Cost
        pathCost = @CalculateFullCost  'world',@setup.link,
                                                  @dungeonOne,
                                                  @dungeonThree,
                                                  @dungeonTwo,
                                                  @lostWoods

        costsMapper = new CostsMapper(pathCost,@dungeonOne,
                                                            @dungeonThree,
                                                            @dungeonTwo)

        # Pushes new costs mapper to the array
        costsArray.push costsMapper

        # Third Path Cost
        pathCost = @CalculateFullCost  'world',@setup.link,
                                                  @dungeonTwo,
                                                  @dungeonOne,
                                                  @dungeonThree,
                                                  @lostWoods

        costsMapper = new CostsMapper(pathCost,@dungeonTwo,
                                                            @dungeonOne,
                                                            @dungeonThree)

        # Pushes new costs mapper to the array
        costsArray.push costsMapper

        # Forth Path Cost
        pathCost = @CalculateFullCost  'world',@setup.link,
                                                  @dungeonTwo,
                                                  @dungeonThree,
                                                  @dungeonOne,
                                                  @lostWoods

        costsMapper = new CostsMapper(pathCost,@dungeonTwo,
                                                            @dungeonThree,
                                                            @dungeonOne)

        # Pushes new costs mapper to the array
        costsArray.push costsMapper

        # Fifth Path Cost
        pathCost = @CalculateFullCost  'world',@setup.link,
                                                  @dungeonThree,
                                                  @dungeonOne,
                                                  @dungeonTwo,
                                                  @lostWoods

        costsMapper = new CostsMapper(pathCost,@dungeonThree,
                                                            @dungeonOne,
                                                            @dungeonTwo)

        # Pushes new costs mapper to the array
        costsArray.push costsMapper

        # Sixth Path Cost
        pathCost = @CalculateFullCost  'world',@setup.link,
                                                  @dungeonThree,
                                                  @dungeonTwo,
                                                  @dungeonOne,
                                                  @lostWoods

        costsMapper = new CostsMapper(pathCost,@dungeonThree,
                                                            @dungeonTwo,
                                                            @dungeonOne)

        # Pushes new costs mapper to the array
        costsArray.push costsMapper

        # Picking the best cost found
        lowestCost = costsArray[0]

        for currentElement in costsArray
          if currentElement.cost < lowestCost.cost
            lowestCost = currentElement

        return lowestCost
