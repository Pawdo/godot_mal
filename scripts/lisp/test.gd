extends Node

@onready var rep: Node = $"../rep"
signal print_request(output: String)

func run_test(file_path: String) -> bool:
	var passed_all_tests: bool = true
	var file_lines: PackedStringArray = FileAccess.get_file_as_string(file_path).split('\n')
	var test_result: String
	for line: String in file_lines:
		if not line or line.begins_with(";;") or line.begins_with(";>>>"):
			continue
		if line.begins_with(";=>"):
			var expected_result: String = line.trim_prefix(";=>")
			print_request.emit("Expecting: "+expected_result)
			if test_result == expected_result:
				print_request.emit("Passed.\n")
			else:
				print_request.emit("Failed.\n")
				passed_all_tests = false
			continue
		test_result = rep.interpret(line)
		print("test result: "+test_result)
	return passed_all_tests


func _on_file_dialog_file_selected(path: String) -> void:
	var passed_all_tests: bool = run_test(path)
	print_request.emit("All tests passed? "+str(passed_all_tests))
