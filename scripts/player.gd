# player.gd
extends CharacterBody3D

# --- Atributos do Jogador (Conforme o seu Roadmap) ---
@export var hp: int = 100
@export var forca: int = 10

# --- Variáveis de Movimento ---
# A velocidade de movimento do jogador em metros por segundo.
@export var speed = 5.0
# A força do salto do jogador.
@export var jump_velocity = 4.5

# A gravidade é obtida das definições do projeto para ser consistente.
# Isto permite-lhe ajustar a gravidade para todo o jogo num só local.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Adiciona a gravidade à velocidade vertical.
	# A gravidade é multiplicada por 'delta' para garantir que o movimento
	# seja independente da taxa de frames (framerate).
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Processa o input para o salto.
	# A ação "ui_accept" está, por defeito, associada à tecla Espaço.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Obtém o vetor de input 2D a partir das ações definidas no Projeto.
	# Input.get_vector() devolve um vetor normalizado, perfeito para direção.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Calcula a direção do movimento no espaço 3D.
	# transform.basis.z é o "frente" do jogador, e transform.basis.x é o "lado".
	# Isto faz com que W seja sempre "para a frente" da personagem, não do mundo.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Aplica o movimento se houver input, caso contrário, abranda.
	if direction:
		# Define a velocidade horizontal com base na direção e velocidade.
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		# Abranda gradualmente o movimento horizontal se não houver input.
		# A função move_toward() é ótima para isto.
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# A função principal que move a personagem e gere colisões.
	# A velocity é atualizada automaticamente pela função para refletir colisões.
	move_and_slide()
