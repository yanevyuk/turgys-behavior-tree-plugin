extends Node
class_name condition

var actionscript;
var logicRoot
var behaviorTree
var blackboard
func _init(lr,bt,bb):
	logicRoot=lr;
	behaviorTree=bt
	blackboard=bb
	pass

func _setScript(cd):
	actionscript=load(cd).new();
	add_child(actionscript)

func _tick():
	if actionscript == null:
		push_error("Condition doesn't have a script")
		return
	if !actionscript.has_method("_tick"):
		push_error("Condition's script does not have a _tick method")
		return
	return actionscript.call("_tick",logicRoot);
	pass
