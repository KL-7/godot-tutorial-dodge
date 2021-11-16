extends CanvasLayer
class_name HUD

signal start_game


### Public

func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over() -> void:
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the monsters!"
	$Message.show()

	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)

func update_max_health(max_health: int) -> void:
	$HealthBar.max_value = max_health

func update_health(health: int) -> void:
	$HealthBar.value = health


### Signals

func _on_StartButton_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout() -> void:
	$Message.hide()
