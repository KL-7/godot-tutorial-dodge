extends Node

export (PackedScene) var Mob

var score: int

onready var mod_spawn: PathFollow2D = $MobPath/MobSpawnLocation

### Callbacks

func _ready() -> void:
	randomize()


### Signals

func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout() -> void:
	update_score(score + 1)

func _on_MobTimer_timeout() -> void:
	add_child(create_mob())

func _on_Player_health_changed(new_health: int) -> void:
	$HurtSound.play()
	$HUD.update_health(new_health)

func _on_Mob_death() -> void:
	update_score(score + 10)

### Private

func new_game() -> void:
	$Music.play()

	$Player.start($StartPosition.position)

	update_score(0)
	$HUD.update_max_health($Player.stats.max_health)
	$HUD.update_health($Player.stats.health)

	$HUD.show_message("Get Ready")
	$StartTimer.start()

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()

	$ScoreTimer.stop()
	$MobTimer.stop()

	get_tree().call_group("mobs", "queue_free")

	$HUD.show_game_over()

func update_score(new_score: int) -> void:
	score = new_score
	$HUD.update_score(new_score)

func create_mob() -> Mob:
	var position = update_mod_spawn_position()
	var direction = random_mod_direction()

	var mob = Mob.instance()
	mob.position = position
	mob.rotation = direction
	mob.linear_velocity = random_mod_velocity(direction, mob.min_speed, mob.max_speed)

	mob.connect("death", self, "_on_Mob_death")

	return mob

func update_mod_spawn_position() -> Vector2:
	mod_spawn.offset = randi()
	return mod_spawn.position

func random_mod_direction() -> float:
	# perpendicular to mob path plus random rotation
	return mod_spawn.rotation + PI / 2 + rand_range(-PI / 4, PI / 4)

func random_mod_velocity(direction: float, min_speed: float, max_speed: float) -> Vector2:
	var velocity = Vector2(rand_range(min_speed, max_speed), 0)
	return velocity.rotated(direction)
