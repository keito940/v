module yaml

import (
	json
	time
)

pub type Object = Integer | Float | TimeStamp | Map | Sequence | String | Json |

pub fn decode() ?voidptr{
	return 0
}

pub fn encode(x voidptr) string{
	return ''
}

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

pub struct TimeStamp {
	
}

pub struct Sequence{
mut:
	values []Object
}

pub struct Map {
mut:
	keys []string
	values []Object
}