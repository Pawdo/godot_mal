extends Control

@export var interpreter: Node
@export var terminal_display: TextEdit
@export var terminal_input: LineEdit

var headless = false

func _ready() -> void:
	headless = DisplayServer.get_name() == "headless"
	if headless:
		SignalHandler.put_line.connect(print_to_stdio)
		var input_line: String
		while true:
			printraw("user> ")
			input_line = OS.read_string_from_stdin()
			if not input_line or input_line.strip_edges() == "quit":
				break
			print_to_stdio(interpreter.interpret(input_line))
		print_to_stdio("\nExiting.")
		get_tree().quit()
	else:
		terminal_input.connect("text_submitted", input_text_submitted)
	
func input_text_submitted(new_text: String) -> void:
	SignalHandler.put_line.emit("user> "+new_text)
	SignalHandler.put_line.emit(interpreter.interpret(new_text))

func _exit_tree() -> void:
	print_orphan_nodes()

func print_to_stdio(string_to_print: String) -> void:
	print(string_to_print)
