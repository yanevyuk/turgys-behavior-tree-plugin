extends Node
class_name repeatuntilfail

var child;

func _setChild(cd):
	child=cd;

func _tick():
	if child==null:
		push_error("Repeater doesn't have a child");
		return
	var retVal = OK;
	while retVal != FAILED:
		retVal = child._tick()
	
	return retVal
	pass