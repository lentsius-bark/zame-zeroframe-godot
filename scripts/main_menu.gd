extends Control

var config_file_path : String = "user://config.cfg"

onready var map_list : ItemList = $SidePanelSpace/SidePanel/MapList

const MIN_MAP_LIST_SIZE = 95
const MAX_MAP_LIST_SIZE = 340

func _ready():
	set_process_input(false)
	map_list.rect_min_size.y = load_setting("main_menu", "map_list_length", 139)

func _input(event):
	if event is InputEventMouseButton:
		#	show mouse and stop listening to input when LMB is unclicked
		if event.button_index == 1 and !event.pressed:
			#	save the length of the box into our config file
			save_setting("main_menu", "map_list_length", map_list.rect_min_size.y)
			
			Input.set_mouse_mode(0)
			var new_mouse_pos = $SidePanelSpace/SidePanel/grab_container/GrabMe.rect_global_position
			new_mouse_pos.x += $SidePanelSpace/SidePanel/grab_container/GrabMe.rect_size.x / 2
			new_mouse_pos.y += $SidePanelSpace/SidePanel/grab_container/GrabMe.rect_size.y / 2			
			Input.warp_mouse_position(new_mouse_pos)
			set_process_input(false)

	elif event is InputEventMouseMotion:
	#	listen to mouse speed and apply it to the rectangle size
	#	ONLY if the change in size is within limits
		var change = event.relative.y
		if map_list.rect_min_size.y + change > MIN_MAP_LIST_SIZE and map_list.rect_min_size.y + change < MAX_MAP_LIST_SIZE:
			map_list.rect_min_size.y += change
			$SidePanelSpace/SidePanel.queue_sort()

func load_setting(section, key, default_value):
	var conf = ConfigFile.new()
	var err = conf.load(config_file_path)
	if err == OK:
		var value = conf.get_value(section, key, default_value)
		return value
	#return the default value should the confgig file not yet exist
	else:
		return default_value
	
func save_setting(section, key, value):
	var conf = ConfigFile.new()
	var err = conf.load(config_file_path)
	conf.set_value(section, key, value)
	conf.save(config_file_path)

func _on_GrabMe_pressed():
	set_process_input(true)
	Input.set_mouse_mode(2)

func play_click() -> void:
	$click.play()