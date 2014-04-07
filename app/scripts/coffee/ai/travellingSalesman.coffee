
define ->
  class TravellingSalesman
    constructor: (setup, astar, world) ->
      @setup = setup
      @astar = astar
      @world = world

      @dungeonOne = setup.world.dungeon1
      @dungeonTwo = setup.world.dungeon2
      @dungeonThree = setup.world.dungeon3
      @lostWoods = setup.world.lostwoods

    calculateFullCost: (map, startPoint, firstStop,
                                secondStop, thirdStop,
                                endPoint) =>

      result = @astar.findPath  map,
                                startPoint.x,
                                startPoint.y,
                                firstStop.x,
                                firstStop.y

      @world.gridEverything()

      #First Path cost
      fullCost = result.cost

      result = @astar.findPath  map,
                                firstStop.x,
                                firstStop.y,
                                secondStop.x,
                                secondStop.y

      @world.gridEverything()

      #Second Path Cost
      fullCost = fullCost + result.cost

      result = @astar.findPath  map,
                                secondStop.x,
                                secondStop.y,
                                thirdStop.x,
                                thirdStop.y

      @world.gridEverything()

      #Third Path Cost
      fullCost = fullCost + result.cost

      result = @astar.findPath  map,
                                thirdStop.x,
                                thirdStop.y,
                                endPoint.x,
                                endPoint.y

      @world.gridEverything()

      # Forth Path Cost
      fullCost = fullCost + result.cost

      return fullCost

    ###
      Possible Combinations
        START,D1,D2,D3,DW
        START,D1,D3,D2,DW
        START,D2,D1,D3,DW
        START,D2,D3,D1,DW
        START,D3,D2,D1,DW
        START,D3,D1,D2,DW
    ###
    calculateBestCost: =>

      # First Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonOne,
                                              @dungeonTwo,
                                              @dungeonThree,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonOne,
                                              @dungeonTwo,
                                              @dungeonThree)

      # Array Mapping costs with it's respective path
      costsArray = [costsMapper]

      # Second Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonOne,
                                              @dungeonThree,
                                              @dungeonTwo,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonOne,
                                              @dungeonThree,
                                              @dungeonTwo)

      # Pushes new costs mapper to the array
      costsArray.push costsMapper

      # Third Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonTwo,
                                              @dungeonOne,
                                              @dungeonThree,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonTwo,
                                              @dungeonOne,
                                              @dungeonThree)

      # Pushes new costs mapper to the array
      costsArray.push costsMapper

      # Forth Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonTwo,
                                              @dungeonThree,
                                              @dungeonOne,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonTwo,
                                              @dungeonThree,
                                              @dungeonOne)

      # Pushes new costs mapper to the array
      costsArray.push costsMapper

      # Fifth Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonThree,
                                              @dungeonOne,
                                              @dungeonTwo,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonThree,
                                              @dungeonOne,
                                              @dungeonTwo)

      # Pushes new costs mapper to the array
      costsArray.push costsMapper

      # Sixth Path Cost
      pathCost = @calculateFullCost  'world', @setup.link,
                                              @dungeonThree,
                                              @dungeonTwo,
                                              @dungeonOne,
                                              @lostWoods

      costsMapper = new CostsMapper(pathCost, @dungeonThree,
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


    #Class to Map Cost + Steps Order
    class CostsMapper
      constructor : (@cost, @firstPoint, @secondPoint, @thirdPoint) ->

