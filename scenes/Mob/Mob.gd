extends RigidBody2D
class_name Mob

signal death

export var min_speed: float = 150
export var max_speed: float = 250
export var damage_increment: int = 10

onready var mob_types: PoolStringArray = $AnimatedSprite.frames.get_animation_names()

var damage: int

### Callbacks

func _ready():
	var type = randi() % mob_types.size()
	$AnimatedSprite.animation = mob_types[type]
	damage = (type + 1) * damage_increment


### Signals

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Hurtbox_area_entered(_area):
	emit_signal("death")
	queue_free()
