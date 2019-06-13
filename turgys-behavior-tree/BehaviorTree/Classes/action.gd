extends Node
class_name action
var actionscript

var logicRoot
var behaviorTree
var blackboard
func _init(lr,bt,bb):
	logicRoot=lr;
	behaviorTree=bt
	blackboard=bb
	pass

func _setScript(scr):
	actionscript=load(scr).new();
	add_child(actionscript)
	
func _tick():
	if actionscript == null:
		push_error("Action doesn't have a script")
		return
	if !actionscript.has_method("_tick"):
		push_error("Action's actionscript does not have a _tick method")
		return
	
	return actionscript.call("_tick",logicRoot);
	pass