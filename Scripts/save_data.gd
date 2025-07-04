class_name SaveData extends Resource

@export var high_score:int = 0

const save_path:String = "user://save_data.tres"

func save() -> void:
	ResourceSaver.save(self, save_path)

static func load_or_create() -> SaveData:
	var res:SaveData
	if FileAccess.file_exists(save_path):
		res = load(save_path) as SaveData
	else:
		res = SaveData.new()
	return res
