extends Node2D

class_name PipePair

var moveSpeed = 0

signal bird_entered
signal point_scored

#@onready var audioPlayer = $AudioStreamPlayer # Ссылка на AudioStreamPlayer

# Устанавливаем скорость движения трубы
func set_speed(new_speed):
	moveSpeed = new_speed
	
func _process(delta):
	position.x += moveSpeed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Обработчик столкновения с телом
func _on_body_entered(body):
	if body is Bird:
		bird_entered.emit()


# Обработчик события набора очка, когда птичка прошла через трубу
func _on_scored_body_entered(body):
	if body is Bird:
		point_scored.emit()
		#audioPlayer.play()
