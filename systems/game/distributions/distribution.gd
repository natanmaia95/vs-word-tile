class_name Distribution
extends Resource

@export var letter_amounts : Dictionary[String, int] = {}
@export var point_values : Dictionary[String, int] = {}
@export var word_list_path : String

@export_multiline var word_list : String

func load_word_list(path = word_list_path) -> bool:
	print_debug("loading word list at: ", path)
	if FileAccess.file_exists(path):
		var file_text = FileAccess.get_file_as_string(path)
		#print(file_text)
		word_list = file_text
		return true
	return false
