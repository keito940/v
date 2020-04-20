// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module parser

import v.ast
import v.table
import v.token

fn (var p Parser) array_init() ast.ArrayInit {
	first_pos := p.tok.position()
	var last_pos := token.Position{}
	p.check(.lsbr)
	// p.warn('array_init() exp=$p.expected_type')
	var array_type := table.void_type
	var elem_type := table.void_type
	var exprs := []ast.Expr
	var is_fixed := false
	if p.tok.kind == .rsbr {
		// []typ => `[]` and `typ` must be on the same line
		line_nr := p.tok.line_nr
		p.check(.rsbr)
		// []string
		if p.tok.kind in [.name, .amp] && p.tok.line_nr == line_nr {
			elem_type = p.parse_type()
			// this is set here becasue its a known type, others could be the
			// result of expr so we do those in checker
			idx := p.table.find_or_register_array(elem_type, 1)
			array_type = table.new_type(idx)
		}
	} else {
		// [1,2,3] or [const]byte
		for i := 0; p.tok.kind != .rsbr; i++ {
			expr := p.expr(0)
			exprs << expr
			if p.tok.kind == .comma {
				p.check(.comma)
			}
			// p.check_comment()
		}
		line_nr := p.tok.line_nr
		$if tinyc {
			// NB: do not remove the next line without testing
			// v selfcompilation with tcc first
			tcc_stack_bug := 12345
		}
		last_pos = p.tok.position()
		p.check(.rsbr)
		// [100]byte
		if exprs.len == 1 && p.tok.kind in [.name, .amp] && p.tok.line_nr == line_nr {
			elem_type = p.parse_type()
			is_fixed = true
		}
	}
	// !
	if p.tok.kind == .not {
		last_pos = p.tok.position()
		p.next()
	}
	if p.tok.kind == .not {
		last_pos = p.tok.position()
		p.next()
	}
	if p.tok.kind == .lcbr && exprs.len == 0 {
		// `[]int{ len: 10, cap: 100}` syntax
		p.next()
		for p.tok.kind != .rcbr {
			key := p.check_name()
			p.check(.colon)
			if !(key in ['len', 'cap', 'init']) {
				p.error('wrong field `$key`, expecting `len`, `cap`, or `init`')
			}
			p.expr(0)
			if p.tok.kind != .rcbr {
				p.check(.comma)
			}
		}
		p.check(.rcbr)
	}
	pos := token.Position{
		line_nr: first_pos.line_nr
		pos: first_pos.pos
		len: last_pos.pos - first_pos.pos + last_pos.len
	}
	return ast.ArrayInit{
		is_fixed: is_fixed
		mod: p.mod
		elem_type: elem_type
		typ: array_type
		exprs: exprs
		pos: pos
	}
}

fn (var p Parser) map_init() ast.MapInit {
	pos := p.tok.position()
	var keys := []ast.Expr
	var vals := []ast.Expr
	for p.tok.kind != .rcbr && p.tok.kind != .eof {
		// p.check(.str)
		key := p.expr(0)
		keys << key
		p.check(.colon)
		val := p.expr(0)
		vals << val
		if p.tok.kind == .comma {
			p.next()
		}
	}
	return ast.MapInit{
		keys: keys
		vals: vals
		pos: pos
	}
}
