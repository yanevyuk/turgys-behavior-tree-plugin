tool
extends Label

export(int) var ID = 0 setget _setID;
signal delete_me(id)

func _setID(val):
	ID = val;
	self.text = String(ID)+"."

func _ready():
	self.connect("delete_me",get_parent(),"_delete_label")
func _on_TextureButton_mouse_entered():
	$Delete.visible = true;
	pass # Replace with function body.

func _on_Label_mouse_entered():
	$Delete.visible = true;
	pass # Replace with function body.

func _on_Label_mouse_exited():
	$Delete.visible = false;
	pass # Replace with function body.


func _on_Delete_pressed():
	emit_signal("delete_me",self)
	pass # Replace with function body.
