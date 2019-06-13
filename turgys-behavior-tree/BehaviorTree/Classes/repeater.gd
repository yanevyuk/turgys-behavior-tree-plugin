extends Node
class_name repeater

var child;

func _setChild(cd):
	child=cd;

var begin = false
func _tick():
	if child==null:
		push_error("Repeater doesn't have a child");
		return
	begin = true
#	var retval
#	while true:
#		retval = child._tick()
#		print(retval)
	pass

var retval = 0
func _process(delta):
	if retval != -1:
		retval=-1;
		retval = child._tick()