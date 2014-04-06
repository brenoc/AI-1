
define ['render/world', 'render/link', 'ai/astar'],
  (World, Link, AStar) ->
    class Adventure
      constructor: (setup) ->
        @setup = setup
        @world = new World(setup)
        @link = new Link(setup, @world)
        @astar = new AStar(setup, @world)

      start: () ->
	    # Hardcoded dungeon addresses
        @dungeonOne =
         x: 24
         y: 1
         
        @dungeonTwo =
         x: 39
         y: 17
        
        @dungeonThree =
         x: 5
         y: 32
         
        @darkWoods =
         x: 7
         y: 6
 
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
        # @link.enter ()
        
        # Walk to the pendant
        # TODO
        
        # Walk Back to the Door
        # TODO
        
        # Leaves Dungeon
        #@link.leave()

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
                                                  @dungeonThree, @darkWoods

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
                                                  @darkWoods
        
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
                                                  @darkWoods
        
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
                                                  @darkWoods
        
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
                                                  @darkWoods
        
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
                                                  @darkWoods
        
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
        