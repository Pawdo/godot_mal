extends Resource
class_name Tokenizer

const token_patterns = {
	Token.types.COMMENT: r';.*$',
	Token.types.WHITESPACE: r'[\s\,]+',
	Token.types.SPLICEUNQUOTE: r'~@',
	Token.types.QUOTE: r'\'',
	Token.types.QUASIQUOTE: r'`',
	Token.types.UNQUOTE: r'~',
	Token.types.DEREF: r'@',
	Token.types.WITHMETA: r'\^',
	Token.types.OPENPARENS: r'\(',
	Token.types.CLOSEPARENS: r'\)',
	Token.types.OPENBRACE: r'\[',
	Token.types.CLOSEBRACE: r'\]',
	Token.types.OPENBRACKET: r'\{',
	Token.types.CLOSEBRACKET: r'\}',
	Token.types.STRING: r'"(?:\\.|[^\\"])*"?',
	Token.types.SYMBOL: r'[^;,\[\]{}()\'`~^@\s]+'
}

static var regex_tokenizer: RegEx

func _init() -> void:
	var pattern_strings: Array[String]
	for token in Token.types.values():
		pattern_strings.push_back("(?<%s>%s)"%[Token.types.keys()[token], token_patterns[token]])
	regex_tokenizer = RegEx.new()
	var error: Error = regex_tokenizer.compile(r'|'.join(pattern_strings))
	assert(error == OK, "Regex did not compile.")
		
func tokenize(input_string: String) -> TokenBuffer:
	var matches: Array[RegExMatch] = regex_tokenizer.search_all(input_string)
	return TokenBuffer.new(matches)
