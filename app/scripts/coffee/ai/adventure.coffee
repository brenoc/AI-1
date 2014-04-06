
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
 
        # Calculating combination of costs
        result = @CalculateBestCost()
        
        # Example of usage:

        # Give the algorithm some destination
        # x, y point of destiny and name of the map
        destination =
          x: 5
          y: 39
          map: 'world'

        # Start timer
        start = new Date().getTime()
        # Call the AStar algorithm
        result = @astar.findPath  destination.map,
                                  @setup.link.x,
                                  @setup.link.y,
                                  dungeonThree.x,
                                  dungeonThree.y
   
        # End timer
        end = new Date().getTime()
        time = end - start

        # ALWAYS call this function after the AStar algorithm
        @world.gridEverything()

        # Makes Link walk
        @moveAlongThePath(result.path)

        ###
        Link may take some actions, like:
        @link.enter() - Link enter the dungeon door (must be over the door)
        @link.leave() - Link leave the dungeon (must be over the door)
        @link.getPendant() - Link take the pendant (must be over the pendant)
        ###

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
        
        #Second Path Cost
        result = @astar.findPath  map,
                                  firstStop.x,
                                  firstStop.y,
                                  secondStop.x,
                                  secondStop.y
        
        fullCost = fullCost + result.cost
        
        #Third Path Cost
        result = @astar.findPath  map,
                                  secondStop.x,
                                  secondStop.y,
                                  thirdStop.x,
                                  thirdStop.y
                                  
        fullCost = fullCost + result.cost
        
        # Forth Path Cost
        result = @astar.findPath  map,
                                  thirdStop.x,
                                  thirdStop.y,
                                  endPoint.x,
                                  endPoint.y
        
        fullCost = fullCost + result.cost
        
        return fullCost
        
       #Possible Combinations
       # START,D1,D2,D3,DW
       # START,D1,D3,D2,DW
       # START,D2,D1,D3,DW
       # START,D2,D3,D1,DW
       # START,D3,D2,D1,DW
       # START,D3,D1,D2,DW
       CalculateBestCost: =>
        
        fullCost = @CalculateFullCost  'world', @setup.link,
                                                  @dungeonOne, @dungeonTwo,
                                                  @dungeonThree, @darkWoods
        