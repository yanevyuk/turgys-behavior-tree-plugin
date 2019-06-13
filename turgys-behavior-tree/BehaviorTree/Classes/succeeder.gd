extends Node
class_name succeeder

var child;
func _init():
	pass

func _setChild(cd):
	child=cd;

func _tick():
	if child==null:
		push_error("Succeeder doesn't have a child");
		return
	var retval = child._tick()
	return OK;
	pass