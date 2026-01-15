extends Node

@export var reader: Node
@export var evaluator: Node
@export var printer: Node

func interpret(line: String, environment: LispEnvironment) -> String:
	var AST: LispType = reader.read(line)
	if AST.error:
		return printer.print_to_string(AST)
	var result: LispType = evaluator.eval(AST, environment)
	var output: String = printer.print_to_string(result)
	return output
