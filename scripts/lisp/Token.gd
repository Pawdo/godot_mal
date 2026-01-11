class_name Token
extends Resource

var type: int
var value: String
var location: int

enum types {WHITESPACE, SPLICEUNQUOTE, QUOTE, QUASIQUOTE, UNQUOTE, DEREF,
				 WITHMETA, OPENPARENS, CLOSEPARENS, OPENBRACE, CLOSEBRACE,
				 OPENBRACKET, CLOSEBRACKET, STRING, COMMENT, SYMBOL}

const quote_types: Dictionary = {
	types.QUOTE: "quote",
	types.SPLICEUNQUOTE: "splice-unquote",
	types.QUASIQUOTE: "quasiquote",
	types.UNQUOTE: "unquote",
	types.DEREF: "deref",
	types.WITHMETA: "with-meta"
}

func _init(init_type: int, init_value: String, init_location: int) -> void:
	self.type = init_type
	self.value = init_value
	self.location = init_location
	
func _to_string() -> String:
	return "%s: %s @%d"%[types.values()[type], value, location]
	
