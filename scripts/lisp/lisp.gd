extends Node

@onready var rep: Node = $rep

var root_environment: LispEnvironment

static var built_ins: Dictionary = {
	"+": func(a, b): return LispType.make_number(str(make_int(a)+make_int(b))),
	"-": func(a, b): return LispType.make_number(str(make_int(a)-make_int(b))),
	"*": func(a, b): return LispType.make_number(str(make_int(a)*make_int(b))),
	"/": func(a, b): return LispType.make_number(str(make_int(a)/make_int(b))),
	"%": func(a, b): return LispType.make_number(str(make_int(a)%make_int(b))),
}

static func make_int(x: LispType) -> int:
	return int(x.value)
	
func _ready() -> void:
	root_environment = LispEnvironment.new()
	for operator in built_ins.keys():
		root_environment.add_definition(operator, LispType.make_built_in(operator, built_ins[operator]))
	
func interpret(input: String) -> String:
	return rep.interpret(input, root_environment)
