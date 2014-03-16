
define ['render/map'], (Map) ->
  class Artist
    constructor: () ->
      # variaveis da classe

    render: =>
      maps = new Map()

      @renderMap(maps.world, $('.map-world tbody'))
      @renderMap(maps.dungeon1, $('.map-dungeon-bottom-left tbody'))
      @renderMap(maps.dungeon2, $('.map-dungeon-bottom-right tbody'))
      @renderMap(maps.dungeon3, $('.map-dungeon-top-right tbody'))

    renderMap: (map, elem) ->
      mapDOM = elem
      y = 0
      for row in map
        x = 0
        for col in row
          $(mapDOM).find('.map-row-'+y+'.map-col-'+x).addClass(col)
          x++
        y++

