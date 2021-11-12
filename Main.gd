extends Node

export (PackedScene) var Mob

var score

onready var mod_spawn = $MobPath/MobSpawnLocation

### Callbacks

func _ready():
	randomize()


### Signals

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1

func _on_MobTimer_timeout():
	add_child(create_mob())


### Private

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func create_mob():
	var position = update_mod_spawn_position()
	var direction = random_mod_direction()

	var mob = Mob.instance()
	mob.position = position
	mob.rotation = direction
	mob.linear_velocity = random_mod_velocity(direction, mob.min_speed, mob.max_speed)

	return mob

func update_mod_spawn_position():
	mod_spawn.offset = randi()
	return mod_spawn.position

func random_mod_direction():
	# perpendicular to mob path plus random rotation
	return mod_spawn.rotation + PI / 2 + rand_range(-PI / 4, PI / 4)

func random_mod_velocity(direction, min_speed, max_speed):
	var velocity = Vector2(rand_range(min_speed, max_speed), 0)
	return velocity.rotated(direction)
