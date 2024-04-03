extends Camera2D


func _on_player_move_camera(top, left, bottom, right):
	self.limit_top = top
	self.limit_left =  left
	
	self.limit_bottom = self.limit_top + bottom
	self.limit_right = self.limit_left + right
	pass # Replace with function body.
