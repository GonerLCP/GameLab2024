extends Node

var roomPrefab = preload("res://Scenes/BaseRoom.tscn")

var maxRooms : int = 10
var minRooms : int = 8

var roomWidth : int = 1920
var roomHeight : int = 1080

var gridSizeX : int = 8
var gridSizeY : int= 10

var QueueDeVecteur = []
var roomObjects = []

var roomGrid = []
var roomCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	roomGrid = make2dArray(gridSizeX, gridSizeY)
	print(roomGrid)
	@warning_ignore("integer_division")
	var initialRoomIndex : Vector2 = Vector2(0,0)
	_StartRoomGenerationFromRoom(initialRoomIndex)
	print(roomGrid)
	pass # Replace with function body.


func _StartRoomGenerationFromRoom(roomIndex :Vector2):
	QueueDeVecteur.push_back(roomIndex)
	var x = roomIndex.x
	var y = roomIndex.y
	roomGrid[x][y] = 1
	roomCount = roomCount +1
	var initialRoom = roomPrefab.instantiate()
	initialRoom.position = _GetPositionFromGridIndex(roomIndex)
	initialRoom.name = str("Room",roomCount)
	add_child(initialRoom)
	#initialRoom le truc avec le get set
	roomObjects.push_back(initialRoom)
	return

func _GetPositionFromGridIndex(gridIndex):
	var gridX : int = gridIndex[0]
	var gridY : int = gridIndex[1]
	@warning_ignore("integer_division")
	return Vector2(roomWidth*(gridX - gridSizeX /2), roomHeight * (gridY - gridSizeY /2))

func inst(pos) : #Fonction d'instnatiation, argument = position du truc
	var instance = roomPrefab.instantiate()
	instance.position = pos
	add_child(instance)

func make2dArray(arrayWidth, arrayHeight): #Fait un tableau à 2 dimentions remplissant par des nulls
	var array = [];
	for i in arrayWidth:
		array.append([])
		for j in arrayHeight :
			array[i].append(null)
	return array
