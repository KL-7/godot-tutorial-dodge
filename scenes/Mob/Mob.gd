extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
export var damage_increment = 10

onready var mob_types = $AnimatedSprite.frames.get_animation_names()

var damage

### Callbacks

func _ready():
	var type = randi() % mob_types.size()
	$AnimatedSprite.animation = mob_types[type]
	damage = (type + 1) * damage_increment


### Signals

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Hurtbox_area_entered(_area):
	queue_free()
