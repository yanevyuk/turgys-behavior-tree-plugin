extends Node

var blackboard = {}

func _add(key: String, val):
	if blackboard.has(key):
		push_warning(self.name+" already has the key '"+key+"'. Add function aborted");
	else:
		blackboard[key] = val;

func _put(key: String, val):
	blackboard[key] = val;

func _remove_key(key: String):
	if blackboard.has(key):
		blackboard.erase(key);
	else:
		push_warning(self.name+" does not have this key.");

func _has_key(key: String):
	return blackboard.has(key)

func _get(key: String):
	return blackboard.get(key);

func _get_key(val):
	for key in blackboard:
		if blackboard.get(key) == val:
			return key
	push_warning("This value was not found in "+self.name)
	return null
