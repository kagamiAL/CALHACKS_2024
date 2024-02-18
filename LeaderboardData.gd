extends Node
var time = Time.get_time_dict_from_system()

var leader_board := []

func _save_leaderboard():
	var leader_board_file = FileAccess.open("user://leaderboard.csv", FileAccess.WRITE)
	for data in leader_board:
		leader_board_file.store_line(str(data[0]) + "," + data[1])

func _load_leaderboard():
	if not FileAccess.file_exists("user://leaderboard.csv"):
		return # Error! We don't have a save to load.
	var leader_board_file = FileAccess.open("user://leaderboard.csv", FileAccess.READ)
	while leader_board_file.get_position() < leader_board_file.get_length():
		var line = leader_board_file.get_line()
		var values = line.split(",")
		leader_board.append([float(values[0]), values[1]])

func _sort_leaderboard():
	leader_board.sort_custom(func(a, b): return a[0] < b[0])

func get_leaderboard():
	_sort_leaderboard()
	return leader_board

func append_leaderboard(score: float):
	leader_board.append([score, Time.get_date_string_from_system() + " (%02d:%02d:%02d)" % [time.hour, time.minute, time.second]])
	_sort_leaderboard()
	_save_leaderboard()

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_leaderboard()
