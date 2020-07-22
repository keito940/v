type Expr = IfExpr | IntegerLiteral
type Stmt = FnDecl | StructDecl
type Node = Expr | Stmt

struct FnDecl {
	pos int
}

struct StructDecl {
	pos int
}


struct IfExpr {
	pos int
}

struct IntegerLiteral {
	val string
}

fn handle(e Expr) string {
	is_literal := e is IntegerLiteral
	assert is_literal
	assert !(e !is IntegerLiteral)
	if e is IntegerLiteral {
		println('int')
	}
	match e {
		IntegerLiteral {
			assert it.val == '12'
			// assert e.val == '12' // TODO
			return 'int'
		}
		IfExpr {
			return 'if'
		}
	}
	return ''
}

fn test_expr() {
	expr := IntegerLiteral{
		val: '12'
	}
	assert handle(expr) == 'int'
	// assert expr is IntegerLiteral // TODO
}

fn test_assignment_and_push() {
	mut expr1 := Expr{}
	mut arr1 := []Expr{}
	expr := IntegerLiteral{
		val: '111'
	}
	arr1 << expr
	match arr1[0] {
		IntegerLiteral {
			arr1 << it
			// should ref/dereference on assignent be made automatic?
			// currently it is done for return stmt and fn args
			expr1 = *it
		}
		else {}
	}
}

// Test moving structs between master/sub arrays
type Master = Sub1 | Sub2

struct Sub1 {
mut:
	val  int
	name string
}

struct Sub2 {
	name string
	val  int
}

fn test_converting_down() {
	mut out := []Master{}
	out << Sub1{
		val: 1
		name: 'one'
	}
	out << Sub2{
		val: 2
		name: 'two'
	}
	out << Sub2{
		val: 3
		name: 'three'
	}
	mut res := []Sub2{cap: out.len}
	for d in out {
		match d {
			Sub2 { res << it }
			else {}
		}
	}
	assert res[0].val == 2
	assert res[0].name == 'two'
	assert res[1].val == 3
	assert res[1].name == 'three'
}

fn test_nested_sumtype() {
	mut a := Node{}
	mut b := Node{}
	a = StructDecl{pos: 1}
	b = IfExpr{pos: 1}
	match a {
		StructDecl {
			assert true
		}
		else {
			assert false
		}
	}
	// TODO: not working
	// assert b is IfExpr
	if b is IfExpr {
		assert true
	}
	else {
		assert false
	}
	c := Node(Expr(IfExpr{pos:1}))
	if c is Expr {
		if c is IfExpr {
			assert true
		}
		else {
			assert false
		}
	}
	else {
		assert false
	}
}

type Abc = int | string

fn test_string_cast_to_sumtype() {
	a := Abc('test')
	match a {
		int {
			assert false
		}
		string {
			assert true
		}
	}
}

fn test_int_cast_to_sumtype() {
	// literal
	a := Abc(111)
	match a {
		int {
			assert true
		}
		string {
			assert false
		}
	}
	// var
	i := 111
	b := Abc(i)
	match b {
		int {
			assert true
		}
		string {
			assert false
		}
	}
}