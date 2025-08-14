# player.gd
extends CharacterBody3D

# --- Atributos do Jogador ---
@export var hp: int = 100
@export var forca: int = 10

# --- Variáveis de Movimento ---
@export var speed = 5.0
@export var jump_velocity = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- Novas Variáveis para a Câmara ---
# A sensibilidade do rato. Pode ajustar este valor no Inspetor.
@export var mouse_sensitivity: float = 0.25
# Uma referência ao nosso nó "Pescoço". O @onready garante que a variável só é
# atribuída quando a cena estiver pronta.
@onready var neck = $Neck


# A função _ready é chamada uma vez quando o nó entra na árvore da cena.
# É o sítio perfeito para configurar o estado inicial.
func _ready():
	# Captura o cursor do rato, escondendo-o e mantendo-o no centro do ecrã.
	# Pressione a tecla 'Esc' para libertar o rato enquanto joga.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# A função _unhandled_input é chamada sempre que há um input que não foi
# processado pela UI ou por outras funções. É ideal para controlos de câmara.
func _unhandled_input(event):
	# Verificamos se o evento de input é um movimento do rato.
	if event is InputEventMouseMotion:
		# Rotação Horizontal (esquerda/direita)
		# Rodamos o corpo inteiro do jogador no eixo Y.
		# Usamos o movimento relativo do rato no eixo X (event.relative.x).
		# O sinal negativo é uma convenção comum, pode invertê-lo se preferir.
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		# Rotação Vertical (cima/baixo)
		# Rodamos APENAS o "Pescoço" no eixo X.
		# Usamos o movimento relativo do rato no eixo Y (event.relative.y).
		neck.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		
		# Limitar a rotação vertical para a câmara não "dar a volta".
		# Limitamos a rotação do pescoço entre -90 e 90 graus.
		# Usamos radianos porque as propriedades de rotação do Godot usam radianos.
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta):
	# --- O código de movimento continua igual ---
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# Usamos a base do "neck" (ou a do jogador, o resultado é o mesmo para a direção horizontal)
	# para que "frente" seja sempre para onde a câmara está a apontar.
	var direction = (neck.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
