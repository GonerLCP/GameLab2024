extends Node2D

var roomPrefab = preload("res://Scenes/BaseRoom.tscn") #brasse/20

var maxRooms : int = 10
var minRooms : int = 8

var gridSizeX : int = 9 #taille de grille max en x
var gridSizeY : int= 9 #taille de grille max en y

var QueueDeVecteur = []
var roomObjects = []

var roomGrid = []
var roomCount = 0

var generationFinie = false #Si vraie alors génération finie, on ne rentre plus dans l'update
var indexTry #Index pour placer les salles dans l'update
# Called when the node enters the scene tree for the first time.
func _ready():
	roomGrid = make2dArray(gridSizeX, gridSizeY)
	#remplirTiles(gridSizeX,gridSizeY)
	print(roomGrid)
	@warning_ignore("integer_division")
	var initialRoomIndex : Vector2 = Vector2(gridSizeX/2,gridSizeY/2)
	_StartRoomGenerationFromRoom(initialRoomIndex)
	print(roomGrid)
	pass # Replace with function body.

func _process(delta):
	if (roomCount <= maxRooms and generationFinie == false ):
		indexTry = QueueDeVecteur[QueueDeVecteur.size()-1]
		_TryGeneration(Vector2(indexTry.x +1,indexTry.y))
		_TryGeneration(Vector2(indexTry.x -1,indexTry.y))
		_TryGeneration(Vector2(indexTry.x,indexTry.y +1))
		_TryGeneration(Vector2(indexTry.x,indexTry.y -1))
		return
	pass

func _StartRoomGenerationFromRoom(roomIndex :Vector2):
	QueueDeVecteur.push_back(roomIndex)
	var x = roomIndex.x
	var y = roomIndex.y
	roomGrid[x][y] = 1
	roomCount += 1
	$TileMap.set_cell(0,roomIndex,1,Vector2i(0, 0),0)
	return


func _TryGeneration(roomIndex : Vector2) :
	
	if(roomCount >= maxRooms) : 
		return
	var randomnum = randi_range(0, 10000)
	if(randomnum%2 ==1) :
		return
	var voisinCount 
	voisinCount = _chercherVoisins(roomIndex)
	if (voisinCount > 1) :
		return
	QueueDeVecteur.push_back(roomIndex)
	roomGrid[roomIndex.x][roomIndex.y] = 1 
	roomCount+=1
	if roomCount >= maxRooms :
		generationFinie = true
	$TileMap.set_cell(0,roomIndex,1,Vector2i(0, 0),0)
	return
	
#func _GetPositionFromGridIndex(gridIndex):
	#var gridX : int = gridIndex[0]
	#var gridY : int = gridIndex[1]
	#@warning_ignore("integer_division")
	#return Vector2(roomWidth*(gridX - gridSizeX /2), roomHeight * (gridY - gridSizeY /2))

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

func remplirTiles(arrayWidth, arrayHeight):
	for i in arrayWidth:
		for j in arrayHeight :
			$TileMap.set_cell(0,Vector2i(i,j),1,Vector2i(0, 0),0)
	return

func _chercherVoisins(roomIndex : Vector2) : 
	var count = 0
	if (roomIndex.x == gridSizeX -1 or roomIndex.y == gridSizeY -1 ) : return count
	if(roomGrid[roomIndex.x +1][roomIndex.y] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x -1][roomIndex.y] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x][roomIndex.y +1] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x][roomIndex.y -1] ==1 ) :  
		count = count +1
	return count
#var initialRoom = roomPrefab.instantiate()
#initialRoom.position = _GetPositionFromGridIndex(roomIndex)
#initialRoom.name = str("Room",roomCount)
#add_child(initialRoom)
