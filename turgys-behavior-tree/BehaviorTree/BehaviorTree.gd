extends Node
var all_nodes;
var realroot;
export(NodePath) var logicRoot
export(String, DIR) var BehaviorTree_Folder = null setget setFolder;
export(PackedScene) var saveddock;
export(Array) var all_connections = [];
export(bool) var enabled =true setget set_enabled
var blackboard = {}

func set_enabled(val):
	enabled=val
	if val:
		_tick()
func setFolder(val):
	BehaviorTree_Folder=val;

func _init():
	all_nodes = {};

func newObj(tag):
	match tag:
		"root":
			return root.new();
		"condition":
			return condition.new(get_node(logicRoot),self,blackboard);
		"action":
			return action.new(get_node(logicRoot),self,blackboard);
		"sequence":
			return sequence.new();
		"selector":
			return selector.new();
		"inverter":
			return inverter.new();
		"repeater":
			return repeater.new();
		"repeatuntilfail":
			return repeatuntilfail.new();
		"succeeder":
			return succeeder.new();

var constructed = false
func _construct():
	#{from_port: 0, from: “GraphNode name 0”, to_port: 1, to: “GraphNode name 1” }
	var dock = saveddock.instance()
	var fromKey;
	var toKey;
	var fromNode;
	var toNode;
	var fromSlot
	var toSlot
	all_nodes.clear()
	for connection in all_connections:
		fromKey = connection[0] #from
		toKey = connection[2] #to
		fromNode = dock.get_node(fromKey)
		toNode = dock.get_node(toKey)
		fromSlot = connection[1] #from_port
		toSlot = connection[3] #to_port
		if !all_nodes.has(fromKey):
			#print("making ", fromKey)
			all_nodes[fromKey] = newObj(fromNode.tag)
		if !all_nodes.has(toKey):
			#print("making ", toKey)
			all_nodes[toKey] = newObj(toNode.tag)
		
		all_nodes[fromKey].add_child(all_nodes[toKey])
		#those objects were created
		if fromNode.tag=="root":
			all_nodes[fromKey]._setChild(all_nodes[toKey]);
			realroot=all_nodes[fromKey];
			self.add_child(realroot)
		elif fromNode.tag=="sequence":
			all_nodes[fromKey]._addChild(all_nodes[toKey],fromSlot)
		elif fromNode.tag=="selector":
			all_nodes[fromKey]._addChild(all_nodes[toKey],fromSlot)
		elif fromNode.tag=="inverter":
			all_nodes[fromKey]._setChild(all_nodes[toKey]);
		elif fromNode.tag=="repeater":
			all_nodes[fromKey]._setChild(all_nodes[toKey]);
		elif fromNode.tag=="repeatuntilfail":
			all_nodes[fromKey]._setChild(all_nodes[toKey]);
		elif fromNode.tag=="succeeder":
			all_nodes[fromKey]._setChild(all_nodes[toKey]);
		
		if toNode.tag=="action":
			all_nodes[toKey]._setScript(toNode.actionscript.get_path());
		elif toNode.tag=="condition":
			all_nodes[toKey]._setScript(toNode.actionscript.get_path());
	constructed = true

func _enter_tree():
	#print("gonna construct")
	constructed=false;
	_construct()
	#print("finished constructing")


func _tick():
	if realroot == null:
		push_error("BehaviorTree doesn't have a root node")
		return
	if constructed == false:
		return
	if not enabled:
		return
	realroot._tick();