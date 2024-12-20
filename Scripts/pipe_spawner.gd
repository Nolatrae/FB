extends Node

class_name PipeSpawner

signal bird_crashed
signal point_scored

var pipePrefab = preload("res://Scene/pipe_pair.tscn")

# Скорость движения труб
@export var pipeMoveSpeed = -150

# Таймер для спавна труб
@onready var spawnTimer = $SpawnTimer

func _ready():
	spawnTimer.timeout.connect(spawn_pipe)
	
func start_spawning_pipes():
	spawnTimer.start()

# Функция для создания и спавна новой пары труб
func spawn_pipe():
	var newPipePair = pipePrefab.instantiate() as PipePair
	add_child(newPipePair)
	
	# Получаем область видимости камеры для определения границ
	var cameraRect = get_viewport().get_camera_2d().get_viewport_rect()
	var screenHalfHeight = cameraRect.size.y / 2
	
	# Позиционируем трубы в правой части экрана (за пределами видимости)
	newPipePair.position.x = cameraRect.end.x
	newPipePair.position.y = randf_range(cameraRect.size.y * 0.15 - screenHalfHeight, cameraRect.size.y * 0.65 - screenHalfHeight)
	
	newPipePair.bird_entered.connect(on_bird_entered)
	newPipePair.point_scored.connect(on_point_scored)
	
	# Устанавливаем скорость движения для новой пары труб
	newPipePair.set_speed(pipeMoveSpeed)
	
func on_bird_entered():
	bird_crashed.emit()
	stop()
	
func stop():
	spawnTimer.stop()
	for newPipePair in get_children().filter(func (child): return child is PipePair):
		(newPipePair as PipePair).moveSpeed = 0

func on_point_scored():
	point_scored.emit()


	
