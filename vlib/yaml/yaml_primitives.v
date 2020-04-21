module yaml

import json
import time

pub type Object = Integer | Float | String | TimeStamp | Map | Sequence | String | Json | Nil

pub fn value(o Object){
	match Object{
		Integer { it.value() }
		Float { it.value() }
		String { it.value() }
	}
}

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

pub struct Nil{
}

pub struct Integer {
mut:
	value i64
}

fn (i Integer) value() i64{
	return value
}

pub struct Float {
mut:
	value f64
}

fn (f Float) value() f64{
	return value
}

pub struct String {
mut:
	value string
}

fn (s String) value() string{
	return value
}

pub struct TimeStamp {
mut:
	value time	
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