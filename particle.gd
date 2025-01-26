extends Node2D

const FORCE_STRENGTH = 100000
const DIST_CUTOFF = 10
const COLLISION_FORCE_STRENGTH = 1000

@export var mass = 1
@export var charge = 1
@export var radius = 10
@export var color = Color(1, 0, 0)

@export var velocity = Vector2(0, 0)
var force = Vector2(0, 0)

var _drag_offset = null

func _ready():
	add_to_group("particle")

func _process(delta: float) -> void:
	force = Vector2(0, 0)

	var all_instances = get_tree().get_nodes_in_group("particle")
	
	for instance in all_instances:
		if instance != self:
			var dist = position.distance_squared_to(instance.position)
			var strength = FORCE_STRENGTH * charge * instance.charge / dist
			if dist < DIST_CUTOFF * DIST_CUTOFF:
				strength = max(strength, COLLISION_FORCE_STRENGTH)
			force += (position - instance.position).normalized() * strength

func _physics_process(delta: float) -> void:
	velocity += force / mass * delta
	
	position += velocity * delta
	
	var vsize = get_viewport().size
	
	if position.x < 0: velocity.x = abs(velocity.x)
	if position.x > vsize.x: velocity.x = -abs(velocity.x)
	if position.y < 0: velocity.y = abs(velocity.y)
	if position.y > vsize.y: velocity.y = -abs(velocity.y)

func _draw():
	draw_circle(Vector2(0, 0), radius, color)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		var was_i_clicked = event.global_position.distance_squared_to(position) <= radius * radius
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if was_i_clicked:
					_drag_offset = event.global_position
				else:
					_drag_offset = null
			else:
				if _drag_offset != null:
					velocity += (event.global_position - _drag_offset) / 2
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and was_i_clicked:
				velocity = Vector2(0, 0)
