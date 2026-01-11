extends ScrollContainer

@onready var terminal_display: VBoxContainer = $TerminalDisplay
	
func scroll_to_bottom() -> void:
	get_v_scroll_bar().value = get_v_scroll_bar().max_value

func _on_main_put_line(line: String) -> void:
	terminal_display.add_line(line)
	await get_tree().create_timer(0.1).timeout
	scroll_to_bottom()
