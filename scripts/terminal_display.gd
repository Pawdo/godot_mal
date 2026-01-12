extends TextEdit

@export var max_lines: int = 1000
@onready var main: Control = $"../../.."

func _ready() -> void:
	SignalHandler.connect("put_line", add_line)

func add_line(line: String) -> void:
	text += line+'\n'
	while self.get_line_count() > max_lines:
		self.remove_line_at(0)
