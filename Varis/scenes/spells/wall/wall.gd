extends Node2D


@export var duration: float = 2.0

func _ready():
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("projectile"):
		body.queue_free()
