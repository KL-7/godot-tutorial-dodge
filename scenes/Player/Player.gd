extends Area2D

signal hit(new_health)
signal death

export var speed = 400
export var max_health = 100

var screen_size
var health = max_health


### Public

func start(pos):
	position = pos
	health = max_health

	show()
	$CollisionShape2D.disabled = false


### Callbacks

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = calc_velocity()

	update_position(velocity, delta)
	update_animation(velocity)


### Signals

func _on_Player_body_entered(body):
	health = max(health - body.damage, 0)

	emit_signal("hit", health)

	if health == 0:
		emit_signal("death")
		hide()
		$CollisionShape2D.set_deferred("disabled", true)


### Private

func calc_velocity():
	var velocity = Vector2()
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	return velocity

func update_position(velocity, delta):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func update_animation(velocity):
	if velocity.length() > 0:
		$AnimationPlayer.play()
	else:
		$AnimationPlayer.stop()

	if velocity.x > 0:
		$AnimationPlayer.current_animation = "move_right"
	elif velocity.x < 0:
		$AnimationPlayer.current_animation = "move_left"
	elif velocity.y > 0:
		$AnimationPlayer.current_animation = "move_down"
	elif velocity.y < 0:
		$AnimationPlayer.current_animation = "move_up"
