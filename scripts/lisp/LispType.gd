class_name LispType
extends Resource

enum types {SYMBOL, LIST, VECTOR, DICTIONARY, STRING, NUMBER, KEY, NIL, TRUE, FALSE, ERROR, FUNCTION}

var type: types
var value: String
var children: Array[LispType]
var body: LispType
var built_in: Callable

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
	
static func make_error(init_value: String) -> LispType:
	return LispType.new(types.ERROR, init_value)

static func make_function(name: String, function_body: LispType) -> LispType:
	var result = LispType.new(types.FUNCTION, name)
	result.body = function_body
	return result
	
static func make_built_in(name: String, function: Callable) -> LispType:
	var result = LispType.new(types.FUNCTION, name)
	result.built_in = function
	return result
	
