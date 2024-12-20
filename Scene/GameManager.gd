extends Node

class_name GameManager

# Перечисление состояний игры
enum GameState {IDLE, RUNNING, ENDED}

var gameState
var maxScore = 0  # Максимальный рекорд

@onready var pipeSpawner = $"../PipeSpawner" as PipeSpawner
@onready var bird = get_node("../Bird") as Bird
@onready var ground = $"../Ground" as Ground
@onready var fade = $"../Fade" as Fade
@onready var ui = $"../UI" as UI

@onready var passSoundPlayer = $"../AudioStreamPlayer"  # Звук для прохождения
@onready var bonusSoundPlayer = $"../AudioStreamPlayer2"  # Звук для достижения 5 очков
@onready var tenSoundPlayer = $"../tenSoundPlayer" # Звук для достижения 10 очков
@onready var deathSoundPlayer = $"../deathSoundPlayer"
@onready var flySoundPlayer = $"../FlySoundPlayer"

 # Начальное количество очков
var points = 0
# Флаг, чтобы отслеживать, использован ли бонусный звук
var lastPointSoundWasBonus = false

# Функция инициализации
func _ready():
	# Загружаем максимальный рекорд
	load_max_score()
	# Устанавливаем начальное состояние игры (IDLE)
	gameState = GameState.IDLE	
	# Подключаем сигналы для различных событий
	bird.game_started.connect(on_game_started)
	pipeSpawner.bird_crashed.connect(end_game)
	ground.bird_crashed.connect(end_game)
	pipeSpawner.point_scored.connect(point_scored)
	
	# Отключаем звук поражения и фонового звука при старте игры
	deathSoundPlayer.stop()
	flySoundPlayer.stop()

# Начало игры
func on_game_started():
	if gameState == GameState.IDLE or gameState == GameState.ENDED:
		gameState = GameState.RUNNING
		pipeSpawner.start_spawning_pipes()
		points = 0
		ui.update_points(points)
		
		# Включаем фоновый звук, когда игра началась
		flySoundPlayer.play()
		
		deathSoundPlayer.stop()

# Завершение игры
func end_game():
	# Запускаем анимацию фейда
	if fade != null: 
		fade.play()
		
	# Воспроизводим звук поражения, когда игра заканчивается
	tenSoundPlayer.stop()
	bonusSoundPlayer.stop()
	flySoundPlayer.stop()
	deathSoundPlayer.play()
	# Останавливаем птичку и другие элементы
	bird.kill()
	pipeSpawner.stop()
	ground.stop()
	
		# Если побит рекорд, сохраняем новый рекорд
	if points > maxScore:
		maxScore = points
		save_max_score()
	# Отображаем экран Game Over
	ui.on_game_over(maxScore, points)

# Набор очков
func point_scored():
	points += 1
	# Обновляем UI с новыми очками
	ui.update_points(points)
	
	if points % 10 == 0:
		# Если очки кратны 10, то проигрываем бонусный звук
		tenSoundPlayer.play()
		lastPointSoundWasBonus = true
	# Если количество очков кратно 5 (но не кратно 10), воспроизводим звук для 5
	elif points % 5 == 0:
		bonusSoundPlayer.play()
		lastPointSoundWasBonus = false
	else:
		# Воспроизводим стандартный звук, если очки не кратны 5 или 10
		if lastPointSoundWasBonus:
			lastPointSoundWasBonus = false
		passSoundPlayer.play()

# Загрузка максимального рекорда из файла
func load_max_score():
	var file = FileAccess.open("res://highscore.txt", FileAccess.READ)
	if file != null:
		maxScore = int(file.get_line())  # Читаем первую строку как максимальный рекорд
		file.close()
	else:
		maxScore = 0  # Если файла нет, установим начальный рекорд в 0

# Сохранение максимального рекорда в файл
func save_max_score():
	var file = FileAccess.open("res://highscore.txt", FileAccess.WRITE)
	if file != null:
		file.store_line(str(maxScore))  # Сохраняем рекорд в файл
		file.close()
