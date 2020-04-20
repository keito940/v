module yaml

import json
import time

pub type Object = Integer | Float | TimeStamp | Map | Sequence | String | Json | Nil

pub fn decode() ?voidptr{
	return 0
}

pub fn encode(x voidptr) string{
	return ''
}

pub struct Key {
var:
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

pub struct Nil{
}

pub struct Integer {
var:
	value int
}

pub struct Float {
var:
	value f64
}

pub struct TimeStamp {
var:
	value time	
}

pub struct Sequence{
var:
	values []Object
}

pub struct Map {
mut:
	keys []string
	values []Object
}