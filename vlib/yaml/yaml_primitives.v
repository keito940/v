module yaml

import (
	time
)

const (
	NULL = 0
)

struct Data{
	squences 	&[]Squence
	maps		&[]Mapping
}

struct YamlVersion {
	major i8 // major version number.
	minor i8 // minor version number.
}

struct YamlTagDirective {
	handle []byte // tag handle
	prefix []byte // tag prefix.
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

struct YamlVal{
	mut:
	integer YAMLInt
	str string
	boolean bool
	squence Squence
}

struct YAMLInt{

}

struct Squence{
	val YAMLVal
}

struct Mapping{
	val YAMLVal
}

struct TimeStamp{
	
}