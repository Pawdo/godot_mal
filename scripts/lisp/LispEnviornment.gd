class_name LispEnvironment
extends Resource

var definitions: Dictionary
var parent: LispEnvironment = null

func _init() -> void:
	definitions = Dictionary()
	
func set_parent(environment_parent: LispEnvironment) -> void:
	self.parent = environment_parent
	
static func make_environment(environment_parent: LispEnvironment) -> LispEnvironment:
	var result = LispEnvironment.new()
	result.set_parent(environment_parent)
	return result
	
func add_definition(name: String, definition: LispType) -> LispType:
	definitions[name] = definition
	return definition

func find(name: String) -> LispType:
	if name in definitions.keys():
		return definitions[name]
	if parent == null:
		return LispType.make_error("%s not found" % name)
	return parent.find(name)
	
func is_defined(name: String) -> bool:
	return find(name).error == ""
