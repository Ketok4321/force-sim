extends Node2D

const INTERACT_RADIUS = 10

@export var proton: PackedScene
@export var electron: PackedScene

var _drag_offset = null
var _drag_particle = null

func get_clicked(event):
	for particle in get_tree().get_nodes_in_group("particle"):
		if event.global_position.distance_to(particle.position) <= max(particle.radius, INTERACT_RADIUS):
			return particle
	
	return null

func _input(event):
	if event is InputEventMouseButton:
		var clicked = get_clicked(event)
		
		if clicked == null and event.pressed:
			_drag_offset = null
			_drag_particle = null
			if event.button_index == MOUSE_BUTTON_LEFT:
				var new_scene = proton.instantiate()
				new_scene.position = event.global_position
				add_child(new_scene)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				var new_scene = electron.instantiate()
				new_scene.position = event.global_position
				add_child(new_scene)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if clicked != null:
					_drag_offset = event.global_position
					_drag_particle = clicked
			else:
				if _drag_offset != null:
					_drag_particle.velocity += (event.global_position - _drag_offset) / 2
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			clicked.queue_free()
