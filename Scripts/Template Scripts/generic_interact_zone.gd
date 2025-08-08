extends Area2D

@onready var player: CharacterBody2D = %Player
@onready var interact_zone_player: Area2D = %InteractZonePlayer	#Initializes reference to InteractZone Area2D attached to player
@onready var texture: MeshInstance2D = $Texture

signal dialogue_initiated	#dialogue initiated is hooked up to the Player node in a scene.
							#It changes the player's position during dialogue, so certain dialogue bugs are fixed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture.visible = true		#hides interaction icon on scene start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and not GlobalVariables.interacting and player.is_on_floor():
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/generic_npc.dialogue"), "start")
		GlobalVariables.interacting = true	#sends signal to disable player movement during dialogue
		emit_signal("dialogue_initiated")	#offsets player one pixel from the floor. This prevents dialogue from looping or jumping when leaving dialogue
	
func _physics_process(_delta: float) -> void:
	if overlaps_area(interact_zone_player):	#player has entered interactable zone
		texture.visible = true			#shows interaction icon when player is in range
	else:
		texture.visible = false			#hide interaction icon when player exits range
	
