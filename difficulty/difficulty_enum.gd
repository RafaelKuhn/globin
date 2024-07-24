class_name Diff
enum { BABY, EASY, MEDI, HARD }

static func debug(value) -> String:
	match value:
		BABY:
			return "[Baby]"
		EASY:
			return "[Easy]"
		MEDI:
			return "[Medi]"
		HARD:
			return "[Hard]"

	push_error("UNHANDLED ENUM VARIANT")
	return "ERROR"
