extends CanvasLayer

class_name UI

@onready var pointsLabel = $MarginContainer/PointsLabel
@onready var gameOverBox = $MarginContainer/GameOverBox
@onready var highscoreLabel = $MarginContainer/GameOverBox/HighscoreLabel

func _ready():
	# Инициализация значений
	pointsLabel.text = "%d" % 0
	gameOverBox.visible = false
	
# Функция обновления очков
func update_points(points: int):
	pointsLabel.text = "%d" % points

# Функция отображения панели "Game Over"
# Обработка окончания игры
func on_game_over(maxScore: int, currentScore: int):
	gameOverBox.visible = true
	highscoreLabel.text = "Max Score: %d" % maxScore

# Функция перезапуска игры
func _on_restart_button_pressed():
	get_tree().reload_current_scene()
