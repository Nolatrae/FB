extends Node2D

class_name Ground

signal bird_crashed

# Скорость движения фона
var scrolling_speed = -150

# Ширина земли
var ground_texture_width = 0

@onready var ground_sprite1 = $Ground1/Sprite1
@onready var ground_sprite2 = $Ground2/Sprite2

func _ready():
	ground_texture_width = ground_sprite1.texture.get_width()
	# Устанавливаем начальную позицию второго спрайта, чтобы он начинался сразу после первого
	ground_sprite2.global_position.x = ground_sprite1.global_position.x + ground_texture_width

func _process(delta):
	ground_sprite1.global_position.x += scrolling_speed * delta
	ground_sprite2.global_position.x += scrolling_speed * delta
	
	# Проверяем, покинул ли первый спрайт экран
	if ground_sprite1.global_position.x < -ground_texture_width:
		# Если да, перемещаем его в конец второго спрайта
		ground_sprite1.global_position.x = ground_sprite2.global_position.x + ground_texture_width

	if ground_sprite2.global_position.x < -ground_texture_width:
		ground_sprite2.global_position.x = ground_sprite1.global_position.x + ground_texture_width

func _body_entered(body): 
	bird_crashed.emit()
	(body as Bird).stop()

func stop():
	# Останавливаем движение земли
	scrolling_speed = 0
