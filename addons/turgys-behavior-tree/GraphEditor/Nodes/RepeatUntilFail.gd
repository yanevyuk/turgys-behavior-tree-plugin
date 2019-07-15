tool
extends GraphNode

signal delete_node(node)
#warning-ignore:unused_class_variable
var color = Color(0.8,0.4,0.8)
#warning-ignore:unused_class_variable
var tag = "repeatuntilfail"
#warning-ignore:unused_class_variable
var slot_counter = 0;
#warning-ignore:unused_class_variable
var slot_array = [];

func _ready():
	pass

func _on_Root_close_request():
	self.clear_slot(0);
	emit_signal("delete_node",self)
	self.queue_free()
	pass # Replace with function body.


