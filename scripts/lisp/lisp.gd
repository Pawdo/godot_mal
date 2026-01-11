extends Node

@onready var rep: Node = $rep

func interpret(input: String) -> String:
	return rep.interpret(input)
