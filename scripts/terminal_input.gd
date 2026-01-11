extends LineEdit
@onready var main: Control = $"../../../.."

func _ready() -> void:
	grab_click_focus()
	grab_focus()
	set_process_unhandled_key_input(true)
	connect("text_submitted", clear_input)
	
func clear_input(_text: String) -> void:
	clear()
