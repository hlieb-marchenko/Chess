class_name PieceFactory
extends RefCounted

const BASE_HEIGHT := 0.1


static func create(type: int, side: int) -> Node3D:
	var root := Node3D.new()
	var material := make_material(side)

	match type:
		Piece.Type.PAWN:
			build_pawn(root, material)
		Piece.Type.KNIGHT:
			build_knight(root, material)
		Piece.Type.BISHOP:
			build_bishop(root, material)
		Piece.Type.ROOK:
			build_rook(root, material)
		Piece.Type.QUEEN:
			build_queen(root, material)
		Piece.Type.KING:
			build_king(root, material)

	if side == Piece.Side.BLACK:
		root.rotation.y = PI
	return root


static func make_material(side: int) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	if side == Piece.Side.WHITE:
		material.albedo_color = Color(0.96, 0.94, 0.88)
	else:
		material.albedo_color = Color(0.13, 0.13, 0.15)
	material.roughness = 0.45
	return material


static func add_cylinder(root: Node3D, y_bottom: float, height: float, bottom_radius: float, top_radius: float, material: Material) -> float:
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = bottom_radius
	mesh.top_radius = top_radius
	mesh.height = height
	mesh.radial_segments = 24

	var part := MeshInstance3D.new()
	part.mesh = mesh
	part.material_override = material
	part.position.y = y_bottom + height / 2.0
	root.add_child(part)
	return y_bottom + height


static func add_sphere(root: Node3D, y_center: float, radius: float, material: Material) -> void:
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0

	var part := MeshInstance3D.new()
	part.mesh = mesh
	part.material_override = material
	part.position.y = y_center
	root.add_child(part)


static func add_box(root: Node3D, position: Vector3, size: Vector3, material: Material, rotation_degrees: Vector3 = Vector3.ZERO) -> void:
	var mesh := BoxMesh.new()
	mesh.size = size

	var part := MeshInstance3D.new()
	part.mesh = mesh
	part.material_override = material
	part.position = position
	part.rotation_degrees = rotation_degrees
	root.add_child(part)


static func add_base(root: Node3D, radius: float, material: Material) -> float:
	return add_cylinder(root, 0.0, BASE_HEIGHT, radius, radius - 0.02, material)


static func build_pawn(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.32, material)
	y = add_cylinder(root, y, 0.35, 0.22, 0.12, material)
	add_sphere(root, y + 0.1, 0.14, material)


static func build_rook(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.34, material)
	y = add_cylinder(root, y, 0.5, 0.26, 0.22, material)
	y = add_cylinder(root, y, 0.1, 0.32, 0.32, material)
	add_cylinder(root, y, 0.15, 0.3, 0.3, material)


static func build_knight(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.34, material)
	y = add_cylinder(root, y, 0.4, 0.26, 0.2, material)
	add_box(root, Vector3(0, y + 0.1, -0.05), Vector3(0.2, 0.36, 0.34), material, Vector3(-25, 0, 0))
	add_box(root, Vector3(0, y + 0.02, -0.2), Vector3(0.16, 0.14, 0.2), material)


static func build_bishop(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.34, material)
	y = add_cylinder(root, y, 0.5, 0.24, 0.08, material)
	y = add_cylinder(root, y, 0.05, 0.14, 0.14, material)
	add_sphere(root, y + 0.1, 0.1, material)


static func build_queen(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.36, material)
	y = add_cylinder(root, y, 0.62, 0.28, 0.1, material)
	y = add_cylinder(root, y, 0.06, 0.2, 0.2, material)
	add_sphere(root, y + 0.1, 0.12, material)


static func build_king(root: Node3D, material: Material) -> void:
	var y := add_base(root, 0.36, material)
	y = add_cylinder(root, y, 0.68, 0.3, 0.12, material)
	y = add_cylinder(root, y, 0.06, 0.2, 0.2, material)
	add_box(root, Vector3(0, y + 0.15, 0), Vector3(0.08, 0.3, 0.08), material)
	add_box(root, Vector3(0, y + 0.2, 0), Vector3(0.22, 0.08, 0.08), material)
