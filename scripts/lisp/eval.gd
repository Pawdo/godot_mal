extends Node
const LT = LispType.types
@export var printer: Node

func eval(AST: LispType, environment: LispEnvironment) -> LispType:
	if environment.is_defined("DEBUG-EVAL"):
		if environment.find("DEBUG-EVAL").type not in [LT.FALSE, LT.NIL]:
			SignalHandler.put_line.emit("EVAL: "+printer.print_to_string(AST))
	match AST.type:
		LT.NUMBER, LT.STRING, LT.KEY, LT.NIL, LT.TRUE, LT.FALSE:
			return AST
		LT.SYMBOL:
			return environment.find(AST.value)
		LT.LIST, LT.VECTOR, LT.DICTIONARY:
			return eval_list(AST, environment)
		_:
			return LispType.make_error("Eval: not implemented yet")

func eval_list(AST: LispType, environment: LispEnvironment) -> LispType:
	var items = AST.children
	if not items:
		return AST
	var results: LispType = LispType.make_list(AST.type, [])
	if AST.type == LT.LIST:
		return apply(items, environment)
	for item in AST.get_contents():
		results.append(eval(item, environment))
	return results
	
func apply(sexpr: Array[LispType], environment: LispEnvironment) -> LispType:
	# var function = environment.find(sexpr[0].value)
	var function = sexpr[0]
	var arguments: Array = sexpr.slice(1)
	if environment.is_defined(function.value):
		function = environment.find(function.value)
	if function.is_built_in:
		var evaluated_argurments: Array
		for arg in arguments:
			var eval_arg: LispType = eval(arg, environment)
			if eval_arg.error:
				return eval_arg
			evaluated_argurments.append(eval_arg)
		return evaluated_argurments.reduce(function.built_in)
	
	if function.type == LT.SYMBOL:
		match function.value:
			"env":
				return print_environment(environment)
			"def!":
				if len(arguments) != 2:
					return LispType.make_error("expected two arguments, received %d" % len(arguments))
				var evaluated_argument = eval(arguments[1], environment)
				if evaluated_argument.error:
					return evaluated_argument
				environment.add_definition(arguments[0].value, evaluated_argument)
				return environment.find(arguments[0].value)
			"let*":
				# (let* (a 3 b 4) (+ a b))
				if len(arguments) != 2:
					return LispType.make_error("expected two arguments, received %d" % len(arguments))
				var bind_list: LispType = arguments[0]
				var appliction: LispType = arguments[1]
				if bind_list.type not in [LT.LIST, LT.VECTOR, LT.DICTIONARY]:
					return LispType.make_error("let* must be followed by a list of definitions (symbol definition ...)")
				var contents: Array = bind_list.get_contents()
				if contents.size() % 2 == 1:
					return LispType.make_error("let* must be followed by a list of definitions (symbol definition ...)")
				var temp_environment: LispEnvironment = LispEnvironment.make_environment(environment)
				for index in range(0, contents.size()-1, 2):
					var symbol: String = contents[index].value
					var definition: LispType = eval(contents[index+1], temp_environment)
					temp_environment.add_definition(symbol, definition)
				return eval(appliction, temp_environment)
			_:
				var result: LispType = LispType.make_list(LT.LIST, [])
				for item in sexpr:
					var item_eval: LispType = eval(item, environment)
					if item_eval.error:
						return item_eval
					result.append(item_eval)
				return result
				
	return LispType.make_error("Apply: not implemented yet")

func print_environment(environment: LispEnvironment, child_environment: Array = []) -> LispType:
	const spacer = "    "
	var definitions: Dictionary = environment.definitions
	var list_o_defs: Array = []
	for item in environment.definitions.keys():
		var def: LispType = definitions[item]
		list_o_defs.append(item+": type: "+LispType.type_names[def.type]+" "+def.value+" built in? "+str(def.is_built_in))
	if child_environment:
		list_o_defs.append("- child environment:")
		for child in child_environment:
			list_o_defs.append(spacer+child)
	if environment.parent:
		return print_environment(environment.parent, list_o_defs)
	SignalHandler.put_line.emit("ENVIRONMENT:")
	for item in list_o_defs:
		SignalHandler.put_line.emit(item)
	return LispType.make_nil()
	
	
