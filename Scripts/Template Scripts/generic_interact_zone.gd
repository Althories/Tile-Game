extends Area2D

@onready var interact_zone_player: Area2D = %InteractZonePlayer	#Initializes reference to InteractZone Area2D attached to player
@onready var texture: MeshInstance2D = $Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture.visible = true		#hides interaction icon on scene start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if overlaps_area(interact_zone_player):	#player has entered interactable zone
		texture.visible = true			#shows interaction icon when player is in range
	else:
		texture.visible = false			#hide interaction icon when player exits range
	
