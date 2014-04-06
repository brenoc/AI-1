#Estrutura de Dados do Terreno:

	class Terreno
		constructor: (@Axis_X, @Axis_Y, @TerrainType) ->

	class TerrainTypes
		@Grass: {@Cost: 10}
		@Sand: {@Cost:20}
		@Forest: {@Cost:100}
		@Montain: {@Cost:150}
		@Water: {@Cost:180}
		@DungeonDoor: {@Cost:0} # ou Zero?
		@MasterSword:{@Cost:0}
		@DungeonFloor:{@Cost:10}


findDungeons: (map) =>
	#Antes do Cacheiro viajante, é preciso achar os dungeons
	dungeonEntrances = []

	for row in map 
		for column in row
			if map[row][column].tipo == Tipo.dungeons
				dungeonEntrances.push (new Terreno (row, column, TerrainTypes.Dungeon))

	return dungeonEntrances

