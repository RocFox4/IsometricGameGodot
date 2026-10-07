extends Node2D

# Referencia al nodo del jugador

# Altura de los niveles superior e inferior
@onready var player = $TileMap/Jugador
enum nivells{
	nivell0 = 0,
	nivell1 = 1,
	nivell2 = 2,
}

# Máscaras de colisión
const MASCARA_NIVELL_2 = 2
const MASCARA_NIVELL_1 = 1
const limitBlockPos = Vector2i(0, 2)
const downlimitblocPos = Vector2i(0, 1)
const leftlimitblocPos = Vector2i(1, 1)
const tileSet0 = 0
const tileSet1 = 4
var originalIndex = 0
var prev_tipus_tile
var last_player_tile_position = Vector2i(-1, -1)
enum TipusTerreny {
	TERRA = 0,
	LAVA = 1,
	RAMPA = 2
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	posar_limits()
	Global.vides = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	detectar_terreny()
func posar_limits():
	var offsets = [
		Vector2i(1, -1),
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(-1, 1)
	]
	var used = $TileMap.get_used_cells(nivells.nivell1)
	for spot in used:
		for offset in offsets:
			# Get the tile data and type
			var tile_data : TileData = $TileMap.get_cell_tile_data(nivells.nivell1, spot)
			var tipus_tile = tile_data.get_custom_data("Terreny")
			# Determine the current spot to check
			var current_spot = spot + offset
			if tipus_tile != TipusTerreny.RAMPA:
				# If the spot is empty
				if $TileMap.get_cell_source_id(nivells.nivell1, current_spot) == -1:
				# Check the offset to determine which limit block to place
					if offset == Vector2i(1, -1):
						$TileMap.set_cell(nivells.nivell1, current_spot, tileSet0, downlimitblocPos)
					elif offset == Vector2i(1, 0):  # Handle down and right direction
						$TileMap.set_cell(nivells.nivell1, current_spot, tileSet0, downlimitblocPos)
					else:
						$TileMap.set_cell(nivells.nivell1, current_spot, tileSet0, leftlimitblocPos)
					
func detectar_terreny():
	var player_tile_position = $TileMap.local_to_map(player.position)
	if player_tile_position != last_player_tile_position:
		last_player_tile_position = player_tile_position
		var tile_data : TileData = $TileMap.get_cell_tile_data(0, player_tile_position)
		if tile_data:
			var tipus_tile = tile_data.get_custom_data("Terreny")
			if prev_tipus_tile != tipus_tile:
				prev_tipus_tile = tipus_tile
				if (tipus_tile == TipusTerreny.LAVA) and player.z_index == 1:
					await get_tree().create_timer(0.4).timeout
					player.mort()
				elif tipus_tile == TipusTerreny.RAMPA:
					originalIndex = player.z_index
					if originalIndex == 1:
						player.z_index = 2
						player.collision_layer = MASCARA_NIVELL_2
						player.collision_mask = MASCARA_NIVELL_2
					else:
						player.z_index = 1
						player.collision_layer = MASCARA_NIVELL_1
						player.collision_mask = MASCARA_NIVELL_1
				

