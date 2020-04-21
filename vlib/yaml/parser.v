module yaml

struct Parser{
	scanner &Scanner
mut:
	tok Token
	prev_tok Token
	peek_tok Token
	table &Table
	is_json bool
}

pub fn (mut p Parser) read_first_token(){
	p.next()
	p.next()
}

fn (mut p Parser) next() {
	p.prev_tok = p.tok
	p.tok = p.peek_tok
	p.peek_tok = p.scanner.scan()
}