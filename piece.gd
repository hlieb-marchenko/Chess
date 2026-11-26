class_name Piece
extends RefCounted

enum Type { PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING }
enum Side { WHITE, BLACK }

var type: Type
var side: Side
var has_moved := false


func _init(piece_type: int, piece_side: int) -> void:
	type = piece_type as Type
	side = piece_side as Side


func copy() -> Piece:
	var result := Piece.new(type, side)
	result.has_moved = has_moved
	return result


func to_letter() -> String:
	var letter := "PNBRQK"[type]
	if side == Side.BLACK:
		return letter.to_lower()
	return letter
