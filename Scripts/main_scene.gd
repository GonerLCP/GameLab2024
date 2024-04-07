extends Node2D

#var ObjetACreer = preload("res://Nodes/ObjetTest.tscn")

@warning_ignore("unused_parameter")
func _on_player_dissmiss_press(pos1, pos2,coll1):
	var stringdeouf = "res://Nodes/Objets/"+ coll1 + ".tscn"
	print(stringdeouf)
	var ObjetACreer = load("res://Nodes/Objets/Cle/"+ coll1 + ".tscn")
	var objetTombe = ObjetACreer.instantiate()
	objetTombe.position = pos1
	#print(ObjetACreer.get_child(0).shape.extents)
	#objetTombe.position.y = ObjetACreer.get_child(0).shape.extents
	add_child(objetTombe)
	get_node("UI/InventaireImage").set_texture(null)
	pass # Replace with function body.
