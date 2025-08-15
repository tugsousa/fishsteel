# portal.gd
extends Area3D

@export_file("*.tscn") var target_scene_path: String

func _on_body_entered(body):
	if target_scene_path.is_empty():
		print("AVISO: O caminho da cena de destino não foi definido neste portal.")
		return

	if body.is_in_group("player"):
		print("Jogador entrou no portal! A viajar para: ", target_scene_path)
		# Use call_deferred to avoid removing physics objects during physics callback
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file(target_scene_path)
