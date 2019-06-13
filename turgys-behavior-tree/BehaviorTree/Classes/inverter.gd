extends Node
class_name inverter

var child;


func _setChild(cd):
	child=cd;

func _tick():
	if child==null:
		push_error("Inverter doesn't have a child");
		return
	var retval = child._tick()
	return !retval;
	pass