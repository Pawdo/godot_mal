class_name LispType
extends Resource

enum types {SYMBOL, LIST, VECTOR, DICTIONARY, STRING, NUMBER, KEY, NIL, TRUE, FALSE, ERROR, FUNCTION}
const type_names = {
	types.SYMBOL: "symbol",
	types.LIST: "list",
	types.VECTOR: "vector",
	types.DICTIONARY: "dictionary",
	types.STRING: "string",
	types.NUMBER: "number",
	types.KEY: "key",
	types.NIL: "nil",
	types.TRUE: "true",
	types.FALSE: "false",
	types.ERROR: "error",
	types.FUNCTION: "function"
}
var type: types
var value: String
var children: Array[LispType]
var body: LispType
var is_built_in: bool = false
var built_in: Callable
var error: String

func _init(init_type: types, init_value: String) -> void:
	type = init_type
	value = init_value
	
static func make_symbol(init_value: String) -> LispType:
	return LispType.new(types.SYMBOL, init_value)
	
static func make_list(list_type: types, list_items: Array[LispType]) -> LispType:
	var result := LispType.new(list_type, "")
	result.children = list_items
	return result

func get_contents() -> Array:
	return children
	
func append(item: LispType) -> void:
	if type not in [types.LIST, types.VECTOR]:
		return make_error("cannot append to %s" %type_names[type])
	children.append(item)
	
static func make_string(init_value: String) -> LispType:
	return LispType.new(types.STRING, init_value)
	
static func make_number(init_value: String) -> LispType:
	return LispType.new(types.NUMBER, init_value)

static func make_key(init_value: String) -> LispType:
	return LispType.new(types.KEY, init_value)

static func make_nil() -> LispType:
	return LispType.new(types.NIL, "nil")

static func make_true() -> LispType:
	return LispType.new(types.TRUE, "true")

static func make_false() -> LispType:
	return LispType.new(types.FALSE, "false")
	
static func make_error(error_message: String) -> LispType:
	var result = LispType.new(types.ERROR, "")
	result.error = error_message
	return result

static func make_function(name: String, function_body: LispType) -> LispType:
	var result = LispType.new(types.FUNCTION, name)
	result.body = function_body
	return result
	
static func make_built_in(name: String, function: Callable) -> LispType:
	var result = LispType.new(types.FUNCTION, name)
	result.built_in = function
	result.is_built_in = true
	return result
	
