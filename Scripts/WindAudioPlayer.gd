extends AudioStreamPlayer


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _process(delta):
	if !playing:
		playing = true
