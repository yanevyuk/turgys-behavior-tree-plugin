tool
extends GraphNode

signal delete_node(node)
var color = Color(0.8,0.4,0.8)
var tag = "sequence"
var label = preload("res://addons/behavior-tree-plugin/GraphEditor/Nodes/SequenceLabel.tscn")
export var slot_counter = 1
export var connections = {}
export var labels = {}

func _ready():
	for seq in labels:
		if !get_parent().has_node(seq):
			labels.erase(seq)
	for seq in connections:
		if !get_parent().has_node(seq):
			connections.erase(seq)
	var add = $Add
	for s in get_children():
		if s != add:
			add_child_below_node(s,add)
func _new_right_connection(from,from_slot,to,to_slot):
	connections[self.name][String(from_slot+1)] = [to,to_slot];
	pass

func _remove_right_connection(from,from_slot,to,to_slot):
	connections[self.name][String(from_slot+1)] = []
	pass

func _on_Sequence_close_request():
	connections.erase(self.name)
	emit_signal("delete_node",self)
	self.queue_free()
	pass # Replace with function body.

func _update_slots():
	for i in range(max(connections.size(),slot_counter)):
		if (i+1)<=slot_counter:
			if !connections[self.name].has(String(i+1)):
				connections[self.name][String(i+1)]=[]
		else:
			if connections[self.name].has(String(i+1)):
				connections[self.name].erase(String(i+1))
	for i in range(1,slot_counter):
		if !self.is_slot_enabled_right(i):
			set_slot(i,false,0,color,true,1,color)

	if is_slot_enabled_right(slot_counter):
		set_slot(slot_counter,false,0,color,false,0,color)

func _on_TextureButton_pressed():
	var newlabel = label.instance()
	newlabel._setID(slot_counter)
	if !connections.has(self.name):
		connections[self.name] = {}
	if !labels.has(self.name):
		labels[self.name]={}
	labels[self.name][String(slot_counter)] = newlabel;
	newlabel.script = load("res://addons/behavior-tree-plugin/GraphEditor/Nodes/SequenceLabel.gd")
	add_child_below_node(get_children()[slot_counter-1],newlabel)
	newlabel.set_owner(get_parent())
	slot_counter+=1
	_update_slots()
	pass # Replace with function body.

func _get_label_with_id(id):
	for s in get_children():
		if s is Label:
			if s.ID == id:
				return s

func _delete_connections():
	for key in connections[self.name]:
		var data = connections[self.name].get(key)
		if !data.empty():
			get_parent().disconnect_node(self.name,int(key)-1,data.front(),data.back())

func _update_connections():
	for key in connections[self.name]:
		var data = connections[self.name].get(key)
		if !data.empty():
			get_parent()._on_GraphEdit_connection_request(self.name,int(key)-1,data.front(),data.back())

func _delete_label(label):
	var ID = label.ID
	var stID = String(ID)
	label.queue_free()
	#_delete_connections()

	var currentdata = connections[self.name][String(ID)]
	if !currentdata.empty():
		get_parent()._on_GraphEdit_disconnection_request(self.name,ID-1,currentdata.front(),currentdata.back())
	for index in range(ID,slot_counter-1):
		labels[self.name][String(index)]=labels[self.name][String(index+1)]
		_get_label_with_id(index+1)._setID(index)
		currentdata = connections[self.name][String(index)]
		var targetdata = connections[self.name][String(index+1)]
		#if current exists but target doesnt exist
		print(currentdata)
		print(targetdata)
		if currentdata.empty() and !targetdata.empty():
			get_parent()._on_GraphEdit_connection_request(self.name,index-1,targetdata.front(),targetdata.back())
		#if both exists
		elif !currentdata.empty() and !targetdata.empty():
			#get_parent()._on_GraphEdit_disconnection_request(self.name,index-1,currentdata.front(),currentdata.back())
			get_parent()._on_GraphEdit_connection_request(self.name,index-1,targetdata.front(),targetdata.back())
		#connections[self.name][String(index)]=connections[self.name][String(index+1)]
	labels[self.name].erase(String(slot_counter-1))
	connections[self.name].erase(String(slot_counter-1))
	
	slot_counter -= 1
	#_update_connections()
	_update_slots()
	pass