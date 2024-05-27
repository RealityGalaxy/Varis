extends Control

@onready var damage_multiplier_slider : HSlider = $MaxHealth
@onready var speed_multiplier_slider : HSlider = $MaxMana
@onready var cooldown_reduction_slider : HSlider = $ManaRegen

func _ready():
	damage_multiplier_slider.connect("value_changed", Callable(self, "_on_damage_multiplier_changed"))
	speed_multiplier_slider.connect("value_changed", Callable(self, "_on_speed_multiplier_changed"))
	cooldown_reduction_slider.connect("value_changed", Callable(self, "_on_cooldown_reduction_changed"))

func _on_damage_multiplier_changed(value):
	Settings.current_mana = value

func _on_speed_multiplier_changed(value):
	Settings.damage_multiplier = value

func _on_cooldown_reduction_changed(value):
	Settings.cooldown_reduction = value
