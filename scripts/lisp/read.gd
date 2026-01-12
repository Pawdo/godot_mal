extends Node

@onready var tokenizer: Tokenizer = Tokenizer.new()

func read(input: String) -> LispType:
	var tokens := tokenizer.tokenize(input)
	if tokens.is_at_end():
		return LispType.make_nil()
	return parse_form(tokens)

func parse_error(token: Token, message: String) -> LispType:
	return LispType.make_error("@%s: Parse error - %s" % [str(token.location), message])
	
func parse_form(tokens: TokenBuffer) -> LispType:
	var token: Token = tokens.peek()
	match token.type:
		Token.types.OPENPARENS, Token.types.OPENBRACE, Token.types.OPENBRACKET:
			return parse_list(tokens, token.type)
		_:
			return parse_atom(tokens)

const token_to_lisp_types = {
	Token.types.OPENPARENS: LispType.types.LIST,
	Token.types.OPENBRACE: LispType.types.VECTOR,
	Token.types.OPENBRACKET: LispType.types.DICTIONARY,
}
func parse_list(tokens: TokenBuffer, type: Token.types) -> LispType:
	if not tokens.consume_expected(type):
		parse_error(tokens.peek(), "list is malformed")
	var end_token: Token.types = Token.types.values()[type+1]
	var result: Array[LispType]
	while not tokens.is_at_end() and tokens.peek().type != end_token:
		var list_item: LispType = parse_form(tokens)
		if list_item.type == LispType.types.ERROR:
			return list_item
		result.append(list_item)
	if tokens.is_at_end() or not tokens.consume_expected(end_token):
		return parse_error(tokens.tokens[-1], "unbalanced brackets")
	return LispType.make_list(token_to_lisp_types[type], result)
	
func parse_atom(tokens: TokenBuffer) -> LispType:
	var token := tokens.peek()
	var types := Token.types
	if token.type in [types.SPLICEUNQUOTE, types.QUOTE, types.QUASIQUOTE, types.UNQUOTE, types.DEREF, types.WITHMETA]:
		return parse_quotes(tokens)
	match token.type:
		types.SYMBOL:
			tokens.consume_expected(types.SYMBOL)
			if token.value.is_valid_float() or token.value.is_valid_int():
				return LispType.make_number(token.value)
			if token.value.begins_with(':'):
				return LispType.make_key(token.value)
			match token.value:
				"nil":
					return LispType.make_nil()
				"true":
					return LispType.make_true()
				"false":
					return LispType.make_false()
				_:
					return LispType.make_symbol(token.value)
		types.STRING:
			return parse_string(tokens)
	return LispType.make_symbol(token.value)
			
enum states {NORMAL, ESCAPE}
func parse_string(tokens: TokenBuffer) -> LispType:
	var peek := tokens.peek()
	tokens.consume_expected(Token.types.STRING)
	if not peek.value.ends_with('"') or len(peek.value) < 2:
		return parse_error(peek, "string is not closed with \".")

	var result: String = ""
	var state: states = states.NORMAL
	for index in range(1, len(peek.value)-1):
		var character := peek.value[index]
		if state == states.ESCAPE:
			match character:
				'n':
					result += '\n'
				'"':
					result += '"'
				_:
					result += character
			state = states.NORMAL
			continue
		if character == '\\':
			state = states.ESCAPE
			continue
		result += character
	if state == states.ESCAPE:
		return parse_error(peek, "string was closed with an escaped quote. If this is intended, add another quote.")
	return LispType.make_string(result)

func parse_quotes(tokens: TokenBuffer) -> LispType:
	var quote := tokens.peek()
	tokens.consume_expected(quote.type)
	var item := parse_form(tokens)
	if item.type == LispType.types.ERROR:
		return item
	var function: LispType = LispType.make_symbol(Token.quote_types[quote.type])
	return LispType.make_list(LispType.types.LIST, [item, function])
