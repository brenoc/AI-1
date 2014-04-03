
define ->
  class Node
    constructor: (x, y, type) ->
      @x = x
      @y = y
      @type = type
      @cost = @getCost(type)

      @g = 0
      @f = 0
      @h = 0

      @opened = null
      @closed = null
      @parent = null

    getCost: (type) ->
      switch type
        when 'G' then return 10
        when 'S' then return 20
        when 'F' then return 100
        when 'M' then return 150
        when 'W' then return 180
        when 'L' then return 10
        when 'D' then return Infinity
        else return 0
