extends "res://particle.gd"

var _gone = false

func _ready() -> void:
	super._ready()
	add_to_group("nucleon")

func _process(delta: float) -> void:
	super._process(delta)
	
	if _gone: return
	var all_instances = get_tree().get_nodes_in_group("nucleon")
	
	for instance in all_instances:
		if instance != self && !instance._gone && instance.radius <= radius:
			var dist = position.distance_squared_to(instance.position)
			if dist < radius * radius:
				position = (position * mass + instance.position * instance.mass) / (mass + instance.mass)
				mass += instance.mass
				charge += instance.charge
				radius = sqrt(radius * radius + instance.radius * instance.radius)
				force += instance.force
				velocity += instance.velocity * instance.mass / mass
				queue_redraw()
				instance._gone = true
				instance.queue_free()
