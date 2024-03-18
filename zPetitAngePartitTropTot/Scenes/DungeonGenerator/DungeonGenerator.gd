extends Node2D

#var roomPrefab = preload("res://Scenes/BaseRoom.tscn") #brasse/20

var maxRooms : int = 15
var minRooms : int = 8

var gridSizeX : int = 9 #taille de grille max en x
var gridSizeY : int= 9 #taille de grille max en y

var QueueDeVecteur = [] #Tableau contenant des vecteurs représentant l'ensemble des positions des salles
var roomObjects = [] #Théoriquement stock les salles générées 
var VecteursSalleSansVoisin = []

var roomGrid = []
var roomCount = 0

var generationFinie = false #Si vraie alors génération finie, on ne rentre plus dans l'update
var indexTry #Index pour placer les salles dans l'update
var FinCherchageDeVoisin = false
var initialRoomIndex : Vector2 #coord room de Depart
# Called when the node enters the scene tree for the first time.
func _ready():
	roomGrid = make2dArray(gridSizeX, gridSizeY)
	remplirTiles(gridSizeX,gridSizeY)
	print(roomGrid)
	@warning_ignore("integer_division")
	initialRoomIndex  = Vector2(gridSizeX/2,gridSizeY/2) #La room de départ sera toujours le milieu de la grille
	_StartRoomGenerationFromRoom(initialRoomIndex)
	print(roomGrid)
	pass # Replace with function body.

func _process(delta):
	if (roomCount <= maxRooms and generationFinie == false ): #Essaie de génerer des salles tant que le nombre de rooms n'est pas dépassé
		#indexTry = QueueDeVecteur[QueueDeVecteur.size()-1]
		#Itere sur une salle déjà générée
		indexTry = QueueDeVecteur.pick_random()
		#Essaie de génerer des salles dans les 4 directions cardinales autout des coordos données 
		_TryGeneration(Vector2(indexTry.x +1,indexTry.y))
		_TryGeneration(Vector2(indexTry.x -1,indexTry.y))
		_TryGeneration(Vector2(indexTry.x,indexTry.y +1))
		_TryGeneration(Vector2(indexTry.x,indexTry.y -1))
		return
	if ( generationFinie == true and FinCherchageDeVoisin == false) :
		_chercherSalleSansVoisin()
		print(VecteursSalleSansVoisin)
		FinCherchageDeVoisin = true
		_salleOrphelineLaplusLoin()
	#if(FinCherchageDeVoisin == true) :
		#for i in VecteursSalleSansVoisin.size() :
			#$TileMap.set_cell(0,VecteursSalleSansVoisin[i],3,Vector2i(0, 0),0)
	pass

func _StartRoomGenerationFromRoom(roomIndex :Vector2): #Fonction qui génère la première salle du niveau 
	QueueDeVecteur.push_back(roomIndex) #Rajoute dans la pile les coordonnées de la salle
	roomGrid[roomIndex.x][roomIndex.y] = 1 #Renseigne dans le tableau qu à cet endroit la il y'a une case, permet de stocker les infos quoi, en réalité on à pas besoin des tilempas le tableau suffit
	roomCount += 1 #Augmente le nombre de room mis
	$TileMap.set_cell(0,roomIndex,4,Vector2i(0, 0),0) #Je vais l'écrire ici pour pas l'oublier : Ca vient chercher dans le noeud TileMapla fonction set_cell qui prend en argument le layer, donc genre l'odre dans la scene, le z dans unity, ensuite la position dans la tilemap, l'id de la tileset et finalement un vecteur de je sais pas à quoi il sert mais j'ai vu un mec sur reddit de mettre ça et ça marche /shrug
	return

func _TryGeneration(roomIndex : Vector2) : #Essaie de generer une salle dans le niveau
	if(roomCount >= maxRooms) : return #Si on dépasse le nombre de rooms, arret de l'essai
	var randomnum = randi_range(0, 10000)
	if(randomnum%2 ==1) : return #Une chance sur deux de l'arret de l'essai
	var voisinCount 
	if (roomIndex.x >= gridSizeX -1 or roomIndex.y >= gridSizeY -1 or roomIndex.x < 0 or roomIndex.y < 0 ) : return #Si on sort de la grille arret de l'essai
	voisinCount = _chercherVoisins(roomIndex)
	if (voisinCount > 1) : return #Si plus d'un voisin arret de l'essai pour éviter d'avoir des salles collées entre elles
	if (roomGrid[roomIndex.x][roomIndex.y] == 1 ) : return #Si room déjà générée à cet endroit arret de l'essai
	QueueDeVecteur.push_back(roomIndex)
	roomGrid[roomIndex.x][roomIndex.y] = 1 
	roomCount+=1
	if roomCount >= maxRooms : generationFinie = true
	$TileMap.set_cell(0,roomIndex,1,Vector2i(0, 0),0)
	return
	
#func _GetPositionFromGridIndex(gridIndex):
	#var gridX : int = gridIndex[0]
	#var gridY : int = gridIndex[1]
	#@warning_ignore("integer_division")
	#return Vector2(roomWidth*(gridX - gridSizeX /2), roomHeight * (gridY - gridSizeY /2))

func inst(pos) : #Fonction d'instnatiation, argument = position du truc
	var instance #= roomPrefab.instantiate()
	instance.position = pos
	add_child(instance)

func make2dArray(arrayWidth, arrayHeight): #Fait un tableau à 2 dimentions remplis de nulls
	var array = [];
	for i in arrayWidth:
		array.append([])
		for j in arrayHeight :
			array[i].append(0)
	return array

func remplirTiles(arrayWidth, arrayHeight): #Rempli entièrement la tilemap par des cases
	for i in arrayWidth:
		for j in arrayHeight :
			$TileMap.set_cell(0,Vector2i(i,j),0,Vector2i(0, 0),0)
	return

func _chercherVoisins(roomIndex : Vector2) : #Cherche dans roomGrid les voisins de la salle. Une salle est forcément connectée au au moins une autre salle, on s'alerte que si count =2. C'est fait pour éviter d'avoir des gros pack de salle
	var count = 0
	if(roomGrid[roomIndex.x +1][roomIndex.y] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x -1][roomIndex.y] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x][roomIndex.y +1] ==1 ) :  
		count = count +1
	if(roomGrid[roomIndex.x][roomIndex.y -1] ==1 ) :  
		count = count +1
	return count

	
func _chercherSalleSansVoisin() :
	for  i in QueueDeVecteur.size() :
		if (QueueDeVecteur[i].x >= gridSizeX -1 or QueueDeVecteur[i].y >= gridSizeY -1 or QueueDeVecteur[i].x < 0 or QueueDeVecteur[i].y < 0 ) : #Si on sort de la grille arret de l'essai
			break
		if (_chercherVoisins(QueueDeVecteur[i]) == 1 ) :
			VecteursSalleSansVoisin.push_back(QueueDeVecteur[i])
	return

func _salleOrphelineLaplusLoin() :
	var additionPointDeDepart = initialRoomIndex.x + initialRoomIndex.y
	var soustractionLaPlusLoin = 0 #Garde en mémoire l'addition la plus grande
	var indexLePlusLoin #Garde en mémoire l'index de l'addition la plus loin
	var additionCurrent #Addition de l'index de la boucle
	for i in VecteursSalleSansVoisin.size() :
		additionCurrent = VecteursSalleSansVoisin[i].x + VecteursSalleSansVoisin[i].y
		if abs(additionCurrent-additionPointDeDepart) > soustractionLaPlusLoin :
			indexLePlusLoin = i
			soustractionLaPlusLoin = abs(additionCurrent-additionPointDeDepart)
	
	$TileMap.set_cell(0,VecteursSalleSansVoisin[indexLePlusLoin],3,Vector2i(0, 0),0)
	roomGrid[VecteursSalleSansVoisin[indexLePlusLoin].x][VecteursSalleSansVoisin[indexLePlusLoin].y] = 3
	VecteursSalleSansVoisin.remove_at(indexLePlusLoin)
	var randomIndex = randi_range(0,VecteursSalleSansVoisin.size()-1)
	$TileMap.set_cell(0,VecteursSalleSansVoisin[randomIndex],2,Vector2i(0, 0),0)
	roomGrid[VecteursSalleSansVoisin[randomIndex].x][VecteursSalleSansVoisin[randomIndex].y] = 2
	return
