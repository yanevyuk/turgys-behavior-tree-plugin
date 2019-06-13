tool
extends MenuButton

var root = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Root.tscn")
var action = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Action.tscn")
var condition = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Condition.tscn")
var sequence = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Sequence.tscn")
var selector = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Selector.tscn")
var inverter = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Inverter.tscn")
var succeeder = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Succeeder.tscn")
var repeater = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/Repeater.tscn")
var repeatuntilfail = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/RepeatUntilFail.tscn")

var popup;
onready var graph = self.get_parent().get_parent();
func _newRoot():
	if graph!= null:
		if !graph.has_node("Root"):
			var new = root.instance();
			new.name = new.name+"_"+String(graph.total_made.get("Root"))
			graph.total_made["Root"] += 1
			graph.add_child(new);
			new.set_owner(graph);
			(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
			new.connect("delete_node",graph,"_node_delete_request")

func _newSequence():
	var new = sequence.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("Sequence"))
	graph.total_made["Sequence"] += 1
	new.set_owner(graph);
	new.connect("delete_node",graph,"_node_delete_request")
	graph.set_selected(new)
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
func _newSelector():
	var new = selector.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("Selector"))
	graph.total_made["Selector"] += 1
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")

func _newInverter():
	var new = inverter.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("Inverter"))
	graph.total_made["Inverter"] += 1
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")
func _newSucceeder():
	var new = succeeder.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("Succeeder"))
	graph.total_made["Succeeder"] += 1
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")
func _newRepeater():
	var new = repeater.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("Repeater"))
	graph.total_made["Repeater"] += 1
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")

func _newRepeatUntilFail():
	var new = repeatuntilfail.instance();
	graph.add_child(new);
	new.name = new.name+"_"+String(graph.total_made.get("RepeatUntilFail"))
	graph.total_made["RepeatUntilFail"] += 1
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")

func _newAction():
	var new = action.instance();
	new.name = new.name+"_"+String(graph.total_made.get("Action"))
	graph.total_made["Action"] += 1
	graph.add_child(new);
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")

func _newCondition():
	var new = condition.instance();
	new.name = new.name+"_"+String(graph.total_made.get("Action"))
	graph.total_made["Action"] += 1
	graph.add_child(new);
	new.set_owner(graph);
	(new as GraphNode).set_offset( get_local_mouse_position()+graph.scroll_offset)
	new.connect("delete_node",graph,"_node_delete_request")


func _on_item_pressed(ID):
	if graph == null:
		return
	match ID:
		0:
			_newRoot();
		2:
			_newSequence();
		3:
			_newSelector();
		5:
			_newInverter()
		6:
			_newSucceeder()
		7:
			_newRepeater()
		8:
			_newRepeatUntilFail()
		10:
			_newAction();
		11:
			_newCondition();

func _ready():
	popup = self.get_popup()
	popup.clear();
	popup.connect("id_pressed", self, "_on_item_pressed")
	popup.add_item("Root");
	popup.add_separator("Composites")
	popup.add_item("Sequence")
	popup.add_item("Selector")
	popup.add_separator("Decorators")
	popup.add_item("Inverter")
	popup.add_item("Succeeder")
	popup.add_item("Repeater")
	popup.add_item("Repeat Until Fail")
	popup.add_separator("Leaves");
	popup.add_item("Action");
	popup.add_item("Condition");
	pass