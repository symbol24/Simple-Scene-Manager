class_name LevelData extends Resource

## Add the path of the levels in order you wish them to be loaded.
@export var levels:Array[String] = []

var current_level:int = -1
var current_path:String = ""

# Getting level path is done by passing an int. -1 = current level, -2 = next level, or an int for any inside the array
func get_level_path(_id :int) -> String:
	if levels.is_empty():
		push_error("Level data does not contain any level paths.")
		return ""
	
	if _id == -1: 
		return current_path
	elif _id == -2: 
		current_level += 1
	else: 
		current_level = _id
		
	var path:String = ""
	if current_level > -1 and current_level < levels.size():
		path = levels[current_level]
		current_path = path
	
	return path
