extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile : Vector2i = Vector2i(0,0)
	tile = tile
	$TileMap.set_cell(0,tile,0,Vector2i(0, 0),0)
	$TileMap.set_cell(0,Vector2i(1,2),0,Vector2i(0, 0),0)
	$TileMap.set_cell(0,Vector2i(1,1),0,Vector2i(0, 0),0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
