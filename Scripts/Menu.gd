extends Control


func _on_play_pressed(): #Play
	get_tree().change_scene_to_file("res://Nodes/main_scene.tscn")
	pass # Replace with function body.



func _on_options_pressed(): #options
	pass # Replace with function body.


func _on_quit_pressed(): #Quit
	get_tree().quit()
	pass # Replace with function body.
