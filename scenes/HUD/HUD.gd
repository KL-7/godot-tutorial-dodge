extends CanvasLayer

signal start_game


### Public

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the monsters!"
	$Message.show()

	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_max_health(max_health):
	$HealthBar.max_value = max_health

func update_health(health):
	$HealthBar.value = health


### Signals

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
