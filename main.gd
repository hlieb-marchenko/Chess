extends Node3D

const SQUARE_SIZE := 1.0
const BOARD_THICKNESS := 0.2

const LIGHT_COLOR := Color(0.93, 0.85, 0.70)
const DARK_COLOR := Color(0.45, 0.30, 0.20)

var light_material: StandardMaterial3D
var dark_material: StandardMaterial3D


func _ready() -> void:
	create_materials()
	create_board()
	create_environment()
	create_light()
	create_camera()


func square_to_world(file: int, rank: int) -> Vector3:
	var x := (file - 3.5) * SQUARE_SIZE
	var z := (3.5 - rank) * SQUARE_SIZE
	return Vector3(x, 0.0, z)


func create_materials() -> void:
	light_material = StandardMaterial3D.new()
	light_material.albedo_color = LIGHT_COLOR
	dark_material = StandardMaterial3D.new()
	dark_material.albedo_color = DARK_COLOR


func create_board() -> void:
	var board := Node3D.new()
	board.name = "Board"
	add_child(board)

	for file in 8:
		for rank in 8:
			var box := BoxMesh.new()
			box.size = Vector3(SQUARE_SIZE, BOARD_THICKNESS, SQUARE_SIZE)

			var square := MeshInstance3D.new()
			square.name = "Square_%d_%d" % [file, rank]
			square.mesh = box
			square.material_override = dark_material if (file + rank) % 2 == 0 else light_material
			square.position = square_to_world(file, rank) + Vector3(0, -BOARD_THICKNESS / 2.0, 0)
			board.add_child(square)


func create_environment() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.12, 0.13, 0.16)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(1, 1, 1)
	env.ambient_light_energy = 0.4

	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)


func create_light() -> void:
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.shadow_enabled = true
	add_child(sun)


func create_camera() -> void:
	var camera := Camera3D.new()
	add_child(camera)
	camera.look_at_from_position(Vector3(0, 9, 9), Vector3.ZERO, Vector3.UP)
	camera.current = true
