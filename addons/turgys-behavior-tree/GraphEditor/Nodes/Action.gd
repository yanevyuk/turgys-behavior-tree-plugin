tool
extends GraphNode

signal delete_node(node)
var color = Color(0.8,0.4,0.8)
var tag = "action"
export(GDScript) var actionscript setget set_actionscript;
var delete_mode = false setget set_delete_mode;
var filedialog
export(String) var actionname = "ACTION" setget set_name

func set_name(val):
	actionname = val.to_upper()
	if has_node("Name"):
		$Name.text = actionname
func set_actionscript(val: GDScript):
	if val != null:
		$TextureButton/ScriptName.text = val.resource_path
		actionscript = val;
		$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script.svg")
	else:
		$TextureButton/ScriptName.text = ""
		actionscript = val;
		$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script_create.svg")

func set_delete_mode(val):
	if actionscript!=null:
		if val != delete_mode:
			if val == false:
				$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script.svg")
			else:
				$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script_remove.svg")
	else:
		$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script_create.svg")

var template = load("D:\\Godot\\Projects\\Behavior Tree Plugin\\addons\\turgys-behavior-tree\\BehaviorTree\\Templates\\action.gd")
func _ready():
	if actionscript == null:
		$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script_create.svg")
	else:
		$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script.svg")
	$TextureButton/PopupMenu.clear();
	$TextureButton/PopupMenu.set_hide_on_state_item_selection(true)
	$TextureButton/PopupMenu.add_item("New Script",0)
	$TextureButton/PopupMenu.add_item("Load Script",1)
	$TextureButton/PopupMenu.make_canvas_position_local(get_global_mouse_position())
	pass

func _on_Action_close_request():
	self.clear_slot(0);
	emit_signal("delete_node",self)
	self.queue_free()
	pass # Replace with function body.

func _new_script():
	var newscript = File.new()
	var scriptname = "action_"+$Name.text+".gd"
	newscript.open(get_parent().folder + "\\" + scriptname, File.WRITE)
	newscript.store_string(template.get_source_code())
	newscript.close()
	set_actionscript(load(get_parent().folder + "\\" + scriptname));
	$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script.svg")
	pass

func _load_script():
	if filedialog == null:
		filedialog = get_node("TextureButton/FileDialog")
		if filedialog == null:
			return
	filedialog.set_current_dir(get_parent().folder)
	filedialog.popup_centered_ratio(0.5)
	pass

func _option_chosen(id):
	print(id)
	if id == 0:
		_new_script()
	elif id == 1:
		_load_script()

func _on_TextureButton_pressed():
	if actionscript == null:
		$TextureButton/PopupMenu.popup(Rect2(get_global_mouse_position()+Vector2(15,0),Vector2(50,50)))
		
	else:
		if delete_mode:
			set_actionscript(null)
			delete_mode=false;
		else:
			print(get_parent().editorinterface.get_base_control().get_children())
			for child in get_parent().editorinterface.get_editor_viewport().get_children():
				if child is ScriptEditor:
					child.show();
			get_parent().editorinterface.edit_resource(actionscript); #load(inNodeWithScript.get_filename()));
			var editorSelection = get_parent().editorinterface.get_selection();
			editorSelection.clear();
			editorSelection.add_node(actionscript);
	pass # Replace with function body.



func _on_Action_resize_request(new_minsize):
	var truemin_x = 104
	var truemin_y = 80
	self.rect_min_size = Vector2(min(new_minsize.x,truemin_x),min(new_minsize.y,truemin_y))
	pass # Replace with function body.

var mouse_is_on = false;
func _on_Name_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_RIGHT and $Name/LineEdit.visible == false:
			$Name/LineEdit.text = $Name.text;
			$Name/LineEdit.visible = true
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	set_name(new_text)
	$Name/LineEdit.text=new_text
	$Name/LineEdit.visible=false;
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	set_actionscript(load(path))
	$TextureButton.texture_normal = load("res://addons/turgys-behavior-tree/GraphEditor/Nodes/icon_script.svg")
	pass # Replace with function body.


func _on_TextureButton_mouse_entered():
	$TextureButton/ScriptName.visible=true
	if actionscript!=null:
		$TextureButton/Remove.visible=true
	pass # Replace with function body.


func _on_TextureButton_mouse_exited():
	$TextureButton/ScriptName.visible = false;
	$TextureButton/Remove.visible = false
	pass # Replace with function body.


func _on_Remove_pressed():
	if actionscript !=null:
		set_actionscript(null)
		$TextureButton/Remove.visible=false
	pass # Replace with function body.


func _on_Remove_mouse_entered():
	if actionscript !=null:
		$TextureButton/Remove.visible=true
	pass # Replace with function body.
