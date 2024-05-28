extends Control

@onready var damage_multiplier_slider : HSlider = $HSlider2/DamageMultiplier
@onready var speed_multiplier_slider : HSlider = $HSlider4/SpeedMultiplier
@onready var damage_reduction_slider : HSlider = $HSlider3/DamageReduction
@onready var max_health_slider : HSlider = $VBoxContainer/MaxHealth
@onready var max_mana_slider : HSlider = $VBoxContainer3/MaxMana
@onready var cooldown_reduction_slider: HSlider = $VBoxContainer2/CooldownReduction
@onready var mana_regen_slider : HSlider = $HSlider/ManaRegen
func _ready():
	damage_multiplier_slider.connect("value_changed", Callable(self, "_on_damage_multiplier_changed"))
	speed_multiplier_slider.connect("value_changed", Callable(self, "_on_speed_multiplier_changed"))
	damage_reduction_slider.connect("value_changed", Callable(self, "_on_damage_reduction_changed"))
	max_health_slider.connect("value_changed", Callable(self, "_on_max_health_changed"))
	max_mana_slider.connect("value_changed", Callable(self, "_on_max_mana_changed"))
	mana_regen_slider.connect("value_changed", Callable(self, "_on_mana_regen_changed"))
	cooldown_reduction_slider.connect("value_changed", Callable(self, "_on_cooldown_reduction_changed"))

func _on_damage_multiplier_changed(value):
	Settings.damage_multiplier = value
	var text : String = $HSlider2/Label.text
	$HSlider2/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]

func _on_speed_multiplier_changed(value):
	Settings.speed_multiplier = value
	var text : String = $HSlider4/Label.text
	$HSlider4/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]

func _on_damage_reduction_changed(value):
	Settings.damage_reduction = value
	var text : String = $HSlider3/Label.text
	$HSlider3/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]
	
func _on_max_health_changed(value):
	Settings.max_health = value
	var text : String = $VBoxContainer/Label.text
	$VBoxContainer/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]
	
func _on_max_mana_changed(value):
	Settings.max_mana = value
	var text : String = $VBoxContainer3/Label.text
	$VBoxContainer3/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]
	
func _on_mana_regen_changed(value):
	Settings.mana_regen = value
	var text : String = $HSlider/Label.text
	$HSlider/Label.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]
	
func _on_cooldown_reduction_changed(value):
	Settings.cooldown_reduction = value
	var text : String = $VBoxContainer2/Label2.text
	$VBoxContainer2/Label2.text = "%s - %.1fx" % [text.get_slice(' - ', 0), value]
