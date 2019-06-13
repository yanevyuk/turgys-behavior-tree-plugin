tool
extends GraphEdit
var folder;
var behavior_tree;
var editorinterface;
signal request_variable_update(obj)
export(Array) var all_connections
export(Dictionary) var total_made = {
	"Root": 0,
	"Sequence": 0,
	"Selector": 0,
	"Inverter": 0,
	"Succeeder": 0,
	"Repeater": 0,
	"RepeatUntilFail": 0,
	"Action": 0,
	"Condition": 0
}

func _update_menu_button():
	if has_node("Panel/MenuButton"):
		get_node("Panel/MenuButton").graph = self
	else:
		_update_menu_button()

func _ready():
	_update_menu_button()
	emit_signal("request_variable_update",self,behavior_tree)
	for conn in all_connections:
		connect_node(conn[0],conn[1],conn[2],conn[3])
	OS.set_low_processor_usage_mode(true);
	add_valid_left_disconnect_type(0);
	add_valid_right_disconnect_type(1);
	add_valid_connection_type(1,0);
	add_valid_connection_type(0,1);

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	#{from_port: 0, from: “GraphNode name 0”, to_port: 1, to: “GraphNode name 1” }

	all_connections.append([from,from_slot,to,to_slot])
	for connection in get_connection_list():
		if connection.get("from")==from and connection.get("from_port") == from_slot:
			disconnect_node (connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))
		if connection.get("to")==to and connection.get("to_port") == to_slot:
			disconnect_node (connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))
	
	if get_node(from).has_method("_new_right_connection"):
		get_node(from)._new_right_connection(from,from_slot,to,to_slot)
	if get_node(from).has_method("_new_left_connection"):
		get_node(to)._new_left_connection(from,from_slot,to,to_slot)
	connect_node(from,from_slot,to, to_slot);
	pass # Replace with function body.


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	if get_node(from).has_method("_remove_right_connection"):
		get_node(from)._remove_right_connection(from,from_slot,to,to_slot)
	if get_node(from).has_method("_remove_left_connection"):
		get_node(to)._remove_left_connection(from,from_slot,to,to_slot)
	
	for conn in all_connections:
		if conn[0] == from and conn[1] == from_slot and conn[2] == to and conn[3] == to_slot:
			all_connections.erase(conn)
	disconnect_node(from,from_slot,to, to_slot);
	pass # Replace with function body.

func _node_delete_request(node):
	var nodename = node.name
	for connection in get_connection_list():
		if connection.get("from")==nodename or connection.get("to")==nodename:
			disconnect_node(connection.get("from"), connection.get("from_port"), connection.get("to"), connection.get("to_port"))


func _on_Save_pressed():
	emit_signal("request_variable_update",self,behavior_tree)
	#currently overrides
	var packed_scene = PackedScene.new()
	packed_scene.pack(self)
	behavior_tree.saveddock = packed_scene;
	var connection_export = []
	for conn in get_connection_list():
		connection_export.append([conn.get("from"),conn.get("from_port"),conn.get("to"),conn.get("to_port")])
	
	all_connections.clear()
	all_connections = connection_export.duplicate(true)
	behavior_tree.all_connections =connection_export.duplicate(true)
	pass # Replace with function body.


func _on_GraphEdit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			#open menu
			$Panel/MenuButton.get_popup().popup(Rect2(get_global_mouse_position(),Vector2(50,50)))
	pass # Replace with function body.

