tool
extends EditorPlugin

var BehaviorTree = preload("res://addons/turgys-behavior-tree/BehaviorTree/BehaviorTree.gd");
var BTico =  preload("res://addons/turgys-behavior-tree/BehaviorTree/icon_tree.svg");
var dock

var dock_map = {}
var current_dock;

func _update_dock_variables(obj,bt):
	if bt == null:
		print("this dock doesnt have bt")
		return
	obj.behavior_tree=bt;
	obj.folder = bt.BehaviorTree_Folder
	obj.editorinterface = get_editor_interface()

func _new_selection():
	var selection = get_editor_interface().get_selection().get_selected_nodes();
	var amountofbt = 0;
	var bt;
	for s in selection:
		if s is BehaviorTree:
			amountofbt+=1;
			bt=s;
	if amountofbt == 1 and selection.size() == 1:
		if current_dock !=null and current_dock!=dock_map[bt]:
			remove_control_from_docks(current_dock);
		#add_control_to_dock(DOCK_SLOT_RIGHT_UL,bt.get_dock());
		
		if dock_map.has(bt):
			current_dock = dock_map.get(bt)
		else:
			current_dock = null
		if current_dock == null:
			if bt.saveddock == null:
				print("creating new graph")
				var newdock = preload("res://addons/turgys-behavior-tree/GraphEditor/VisualEditor.tscn").instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
				newdock.connect("request_variable_update",self,"_update_dock_variables")
				newdock.behavior_tree=bt;
				newdock.folder=bt.BehaviorTree_Folder;
				newdock.editorinterface = get_editor_interface()
				newdock._on_Save_pressed()
				dock_map[bt] = newdock
				current_dock=dock_map[bt]
			else:
				var loadeddock = bt.saveddock.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
				loadeddock.behavior_tree=bt;
				loadeddock.all_connections = bt.all_connections.duplicate(true)
				loadeddock.folder=bt.BehaviorTree_Folder;
				loadeddock.editorinterface = get_editor_interface()
				dock_map[bt] = loadeddock
				current_dock=dock_map[bt]
			
			add_control_to_dock(DOCK_SLOT_RIGHT_UL,current_dock);
		else:
			add_control_to_dock(DOCK_SLOT_RIGHT_UL,current_dock);
	elif current_dock != null:
		remove_control_from_docks(current_dock);
		current_dock = null;
	pass

func _enter_tree():
	#add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	add_custom_type("BehaviorTree", "Node",BehaviorTree,BTico);
	get_editor_interface().get_selection().connect("selection_changed",self,"_new_selection");
func _exit_tree():
	remove_custom_type("BehaviorTree");