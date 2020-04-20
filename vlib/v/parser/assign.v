// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module parser

import v.ast
import v.table
import v.token

fn (var p Parser) assign_stmt() ast.Stmt {
	is_static := p.tok.kind == .key_static
	if is_static {
		p.next()
	}
	idents := p.parse_assign_lhs()
	op := p.tok.kind
	p.next()	// :=, =
	pos := p.tok.position()
	exprs := p.parse_assign_rhs()
	is_decl := op == .decl_assign
	for i, ident in idents {
		known_var := p.scope.known_var(ident.name)
		if !is_decl && !known_var {
			p.error('unknown variable `$ident.name`')
		}
		if is_decl && ident.kind != .blank_ident {
			if p.scope.known_var(ident.name) {
				p.error('redefinition of `$ident.name`')
			}
			if idents.len == exprs.len {
				p.scope.register(ident.name, ast.Var{
					name: ident.name
					expr: exprs[i]
					is_mut: ident.is_mut || p.inside_for
				})
			} else {
				p.scope.register(ident.name, ast.Var{
					name: ident.name
					is_mut: ident.is_mut || p.inside_for
				})
			}
		}
	}
	return ast.AssignStmt{
		left: idents
		right: exprs
		op: op
		pos: pos
		is_static: is_static
	}
}

// TODO: is it possible to merge with AssignStmt?
pub fn (var p Parser) assign_expr(left ast.Expr) ast.AssignExpr {
	op := p.tok.kind
	p.next()
	pos := p.tok.position()
	val := p.expr(0)
	match left {
		ast.IndexExpr {
			// it.mark_as_setter()
			it.is_setter = true
		}
		else {}
	}
	node := ast.AssignExpr{
		left: left
		val: val
		op: op
		pos: pos
	}
	return node
}

fn (var p Parser) parse_assign_lhs() []ast.Ident {
	var idents := []ast.Ident
	for {
		is_mut := p.tok.kind == .key_mut || p.tok.kind == .key_var
		if is_mut {
			p.next()
		}
		is_static := p.tok.kind == .key_static
		if is_static {
			p.check(.key_static)
		}
		var ident := p.parse_ident(false, false)
		ident.is_mut = is_mut
		ident.info = ast.IdentVar{
			is_mut: is_mut
			is_static: is_static
		}
		idents << ident
		if p.tok.kind == .comma {
			p.check(.comma)
		} else {
			break
		}
	}
	return idents
}

// right hand side of `=` or `:=` in `a,b,c := 1,2,3`
fn (var p Parser) parse_assign_rhs() []ast.Expr {
	var exprs := []ast.Expr
	for {
		expr := p.expr(0)
		exprs << expr
		if p.tok.kind == .comma {
			p.check(.comma)
		} else {
			break
		}
	}
	return exprs
}
