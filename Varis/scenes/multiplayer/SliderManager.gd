extends Control

@onready var damage_multiplier_slider : HSlider = $DamageMultiplier
@onready var speed_multiplier_slider : HSlider = $SpeedMultiplier
@onready var damage_reduction_slider : HSlider = $DamageReduction
@onready var max_health_slider : HSlider = $MaxHealth
@onready var max_mana_slider : HSlider = $MaxMana
@onready var mana_regen_slider : HSlider = $ManaRegen
func _ready():
	damage_multiplier_slider.connect("value_changed", Callable(self, "_on_damage_multiplier_changed"))
	speed_multiplier_slider.connect("value_changed", Callable(self, "_on_speed_multiplier_changed"))
	damage_reduction_slider.connect("value_changed", Callable(self, "_on_damage_reduction_changed"))
	max_health_slider.connect("value_changed", Callable(self, "_on_max_health_changed"))
	max_mana_slider.connect("value_changed", Callable(self, "_on_max_mana_changed"))
	mana_regen_slider.connect("value_changed", Callable(self, "_on_mana_regen_changed"))

func _on_damage_multiplier_changed(value):
	Settings.damage_multiplier = value

func _on_speed_multiplier_changed(value):
	Settings.speed_multiplier = value

func _on_damage_reduction_changed(value):
	Settings.damage_reduction = value
	
func _on_max_health_changed(value):
	Settings.max_health = value
	
func _on_max_mana_changed(value):
	Settings.max_mana = value
	
func _on_mana_regen_changed(value):
	Settings.mana_regen = value
