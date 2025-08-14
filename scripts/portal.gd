# portal.gd
extends Area3D

# Com @export, podemos definir o caminho do mapa de destino diretamente no editor do Godot.
# Isto torna o script reutilizável!
@export_file("*.tscn") var target_scene_path: String

# Esta função será chamada quando um corpo físico entrar na área.
func _on_body_entered(body):
	# Primeiro, verificamos se o caminho de destino foi definido. Se não, não fazemos nada.
	if target_scene_path.is_empty():
		print("AVISO: O caminho da cena de destino não foi definido neste portal.")
		return

	# A seguir, verificamos se o corpo que entrou é o jogador.
	# Para isto funcionar, temos que adicionar o jogador ao grupo "player".
	if body.is_in_group("player"):
		print("Jogador entrou no portal! A viajar para: ", target_scene_path)
		get_tree().change_scene_to_file(target_scene_path)
