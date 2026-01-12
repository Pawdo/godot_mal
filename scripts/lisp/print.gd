extends Node

const types := LispType.types
func print_to_string(input: LispType, escape_strings = true) -> String:
	match input.type:
		types.SYMBOL, types.NUMBER, types.NIL, types.TRUE, types.FALSE, types.KEY:
			return input.value
		types.STRING:
			if escape_strings:
				return escape_string(input.value)
			return '"'+input.value+'"'
		types.LIST, types.VECTOR, types.DICTIONARY:
			return list_to_string(input)
		types.ERROR:
			return "ERROR: "+input.value
	return "not implemented"
		
func escape_string(input: String) -> String:
	var result: String = '"'
	for character in input:
		match character:
			'\n':
				result += '\\n'
			'\\':
				result += '\\\\'
			'"':
				result += '\\"'
			_:
				result += character
	result += '"'
	return result

func list_to_string(input: LispType) -> String:
	var results: Array = []
	for item in input.get_contents():
		results.append(print_to_string(item))
	var result: String = " ".join(results)
	match input.type:
		types.VECTOR:
			result = '['+result+']'
		types.LIST:
			result = '('+result+')'
		types.DICTIONARY:
			result = '{'+result+'}'
			
	return result
