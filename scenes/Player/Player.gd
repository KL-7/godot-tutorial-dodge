extends Area2D

signal hit

export var speed = 400
var screen_size


### Public

func start(pos):
	position = pos
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

func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
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
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
