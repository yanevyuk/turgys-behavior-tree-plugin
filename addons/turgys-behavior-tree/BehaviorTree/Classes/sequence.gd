extends Node
class_name sequence

var children = [];
func _init():
	pass

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
		push_error("Sequence children null")
		return
	if children.empty():
		push_error("Sequence requires atleast one child")
		return
	
	var finalRet = FAILED
	if children!=null:
		for child in children:
			var retVal = child.front()._tick();
			
			finalRet = retVal
			if retVal != OK:
				break;
	return finalRet
	pass
