extends Node
class_name root

var child;
func _init():
	pass

func _setChild(cd):
	child=cd;

func _tick():
	if child==null:
		push_error("Root doesn't have a child");
		return
	var retval = child._tick()
	return retval;
	pass