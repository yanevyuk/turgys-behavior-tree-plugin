extends Node
class_name selector

var children = [];
class MyCustomSorter:
	static func sort(a, b):
		if a[1] < b[1]:
			return true
		return false

func _addChild(child,fromslot):
	children.append([child,fromslot])
	children.sort_custom(MyCustomSorter,"sort")

func _tick():
	if children==null:
		push_error("Selector children null")
		return
	if children.empty():
		push_error("Selector requires atleast one child")
		return
	var finalRet = FAILED
	for child in children:
		var retVal = child.front()._tick();
		
		finalRet = retVal
		if retVal == OK:
			break;
	return finalRet
	pass
