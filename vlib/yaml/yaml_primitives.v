module yaml

import (
	time
)

pub type Object = Integer | Float | TimeStamp | Map | Sequence | String |

pub struct Key {
mut:
	key string
	val Object
}

enum YamlEncodeing {
	any
	utf8
	utf16le
	utf16be
}

enum YamlBreak {
	any
	cr // CR for line breaks.
	lf // LF for line breaks.
	crlf // CR+LF line breaks.
}

pub struct Integer {
mut:
	value int
}

pub struct Float {
mut:
	value f64
}

pub struct Sequence{
mut:
	values []Object
}

struct Map {
mut:
	keys []string
	values []Object
}