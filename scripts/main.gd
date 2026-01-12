extends Control

@export var interpreter: Node
@export var terminal_display: TextEdit
@export var terminal_input: LineEdit

var headless = false

func _ready() -> void:
	headless = DisplayServer.get_name() == "headless"
	if headless:
		var input_line: String
		while input_line != "quit":
			printraw("user> ")
			input_line = OS.read_string_from_stdin()
			if not input_line:
				break
			print(interpreter.interpret(input_line))
		print("\nExiting.")
		get_tree().quit()
	else:
		terminal_input.connect("text_submitted", input_text_submitted)
	
func input_text_submitted(new_text: String) -> void:
	SignalHandler.put_line.emit("user> "+new_text)
	SignalHandler.put_line.emit(interpreter.interpret(new_text))

func _exit_tree() -> void:
	print_orphan_nodes()
	
