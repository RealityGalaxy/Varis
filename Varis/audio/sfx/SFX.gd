extends Node

# Misc. -----------------------------------

func button_click():
	$ButtonClick.play()

func hit():
	$Hit.play()
	
func round_end():
	$RoundEnd.play()

func card_spawn():
	$CardSpawn.play()

func round_lose():
	$RoundLose.play()

# Spells ----------------------------------

func spell_basic():
	$SpellBasic.play()

func spell_air():
	$SpellAir.play()

func spell_airgate():
	$SpellAirGate.play()

func spell_earth():
	$SpellEarth.play()

func spell_fire():
	$SpellFire.play()

func spell_shield():
	$SpellShield.play()

func spell_water():
	$SpellWater.play()

func spell_windwall():
	$SpellWindWall.play()
