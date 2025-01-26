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
