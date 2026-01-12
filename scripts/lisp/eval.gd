extends Node

func eval(AST: LispType, environment: LispEnvironment) -> LispType:
	const LT = LispType.types
	match AST.type:
		LT.NUMBER, LT.STRING, LT.KEY, LT.NIL, LT.TRUE, LT.FALSE:
			return AST
		LT.SYMBOL:
			return environment.find(AST.value)
		LT.LIST, LT.VECTOR, LT.DICTIONARY:
			var items = AST.children
			if not items:
				return AST
			var results: LispType = LispType.make_list(AST.type, [])
			for item in items:
				var item_result = eval(item, environment)
				if item_result.type == LT.ERROR:
					return item_result
				results.children.append(item_result)
			if AST.type != LispType.types.LIST:
				return results
			results = apply(results)
			return results
		_:
			return LispType.make_error("Eval: not implemented yet")

func apply(sexpr: LispType) -> LispType:
	var function = sexpr.get_contents()[0]
	var arguments = sexpr.children.slice(1)
	if function.built_in:
		return arguments.reduce(function.built_in)
	return LispType.make_error("Apply: not implemented yet")
