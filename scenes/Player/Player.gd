extends Area2D

signal hit(new_health)
signal death

export var speed = 400
export var max_health = 100

enum {
	MOVE,
	ATTACK
}

var screen_size
var health = max_health
var state = MOVE


### Public

func start(pos):
	position = pos
	health = max_health

	show()
	$CollisionShape2D.disabled = false

func attack_finish():
	state = MOVE

### Callbacks

func _ready():
	screen_size = get_viewport_rect().size
	$AnimationTree.active = true
	hide()

func _process(delta):
	match state:
		MOVE:
			process_move(delta)
		ATTACK:
			process_attack()


### Signals

func _on_Player_body_entered(body):
	health = max(health - body.damage, 0)

	emit_signal("hit", health)

	if health == 0:
		emit_signal("death")
		hide()
		$CollisionShape2D.set_deferred("disabled", true)


### Private

func process_move(delta):
	var input_vector = calc_input_vector()

	update_position(input_vector, delta)
	update_animation(input_vector)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func process_attack():
	$AnimationTree.get("parameters/playback").travel("attack")

func calc_input_vector():
	var input_vector = Vector2()
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	return input_vector

func update_position(input_vector, delta):
	position += input_vector * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func update_animation(input_vector):
	if input_vector.length() > 0:
		$AnimationTree.set("parameters/idle/blend_position", input_vector)
		$AnimationTree.set("parameters/move/blend_position", input_vector)
		$AnimationTree.set("parameters/attack/blend_position", input_vector)
		$AnimationTree.get("parameters/playback").travel("move")
	else:
		$AnimationTree.get("parameters/playback").travel("idle")
