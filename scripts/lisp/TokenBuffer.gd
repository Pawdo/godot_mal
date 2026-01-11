class_name TokenBuffer
extends Resource


var tokens: Array[Token]
var index: int

func _init(regex_match_list: Array[RegExMatch]) -> void:
	for token_match in regex_match_list:
		var name: String = token_match.names.keys()[0]
		var type: int = Token.types[name]
		var token = Token.new(type, token_match.get_string(), token_match.get_start())
		if token.type == Token.types.COMMENT or token.type == Token.types.WHITESPACE:
			continue
		tokens.push_back(token)
		
func peek() -> Token:
	if index >= tokens.size():
		return null
	return tokens[index]
	
func next() -> Token:
	index += 1
	if index >= tokens.size():
		return null
	return tokens[index]
	
func consume_expected(expected_type: int) -> bool:
	if peek().type == expected_type:
		index += 1
		return true
	return false
	
func is_at_end() -> bool:
	return index >= tokens.size()
