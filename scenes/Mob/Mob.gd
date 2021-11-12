extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

onready var mob_types = $AnimatedSprite.frames.get_animation_names()


### Callbacks

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


### Signals

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
