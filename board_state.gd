class_name BoardState
extends RefCounted

const BOARD_SIZE := 8
const BACK_RANK := [
	Piece.Type.ROOK,
	Piece.Type.KNIGHT,
	Piece.Type.BISHOP,
	Piece.Type.QUEEN,
	Piece.Type.KING,
	Piece.Type.BISHOP,
	Piece.Type.KNIGHT,
	Piece.Type.ROOK,
]

var squares: Array = []
var side_to_move := Piece.Side.WHITE


func _init() -> void:
	squares.resize(BOARD_SIZE * BOARD_SIZE)
	squares.fill(null)


static func square_name(square: Vector2i) -> String:
	return "abcdefgh"[square.x] + str(square.y + 1)


func index_of(square: Vector2i) -> int:
	return square.y * BOARD_SIZE + square.x


func is_inside(square: Vector2i) -> bool:
	return square.x >= 0 and square.x < BOARD_SIZE and square.y >= 0 and square.y < BOARD_SIZE


func get_piece(square: Vector2i) -> Piece:
	return squares[index_of(square)]


func set_piece(square: Vector2i, piece: Piece) -> void:
	squares[index_of(square)] = piece


func remove_piece(square: Vector2i) -> Piece:
	var piece := get_piece(square)
	set_piece(square, null)
	return piece


func setup_start_position() -> void:
	squares.fill(null)
	for file in BOARD_SIZE:
		set_piece(Vector2i(file, 0), Piece.new(BACK_RANK[file], Piece.Side.WHITE))
		set_piece(Vector2i(file, 1), Piece.new(Piece.Type.PAWN, Piece.Side.WHITE))
		set_piece(Vector2i(file, 6), Piece.new(Piece.Type.PAWN, Piece.Side.BLACK))
		set_piece(Vector2i(file, 7), Piece.new(BACK_RANK[file], Piece.Side.BLACK))
	side_to_move = Piece.Side.WHITE


func find_king(side: Piece.Side) -> Vector2i:
	for square in get_squares_of(side):
		if get_piece(square).type == Piece.Type.KING:
			return square
	return Vector2i(-1, -1)


func get_squares_of(side: Piece.Side) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for rank in BOARD_SIZE:
		for file in BOARD_SIZE:
			var square := Vector2i(file, rank)
			var piece := get_piece(square)
			if piece != null and piece.side == side:
				result.append(square)
	return result


func copy() -> BoardState:
	var result := BoardState.new()
	for i in squares.size():
		if squares[i] != null:
			result.squares[i] = squares[i].copy()
	result.side_to_move = side_to_move
	return result


func to_text() -> String:
	var lines: Array[String] = []
	for rank in range(BOARD_SIZE - 1, -1, -1):
		var line := ""
		for file in BOARD_SIZE:
			var piece := get_piece(Vector2i(file, rank))
			line += "." if piece == null else piece.to_letter()
			line += " "
		lines.append(line.strip_edges())
	return "\n".join(lines)
