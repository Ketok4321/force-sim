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
				force += instance.force # TODO: this causes very minor momentum conservation errors
				velocity = (velocity * mass + instance.velocity * instance.mass) / (mass + instance.mass)
				
				mass += instance.mass
				charge += instance.charge
				radius = sqrt(radius * radius + instance.radius * instance.radius)
				queue_redraw()
				instance._gone = true
				instance.queue_free()
