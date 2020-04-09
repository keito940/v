module yaml

struct YamlVersion {
	major i8 // major version number.
	minor i8 // minor version number.
}

struct YamlTagDirective {
	handle []byte // tag handle
	prefix []byte // tag prefix.
}

enum EventKind{
	no_event
	stream_start
	stream_end
	document_start
	document_end
	mapping_start
	mapping_end
	sequence_start
	sequence_end
	scalar
	alias
}

enum ScalarKind{
	any
	plain
	single_quoted
	double_quoted
	literal
	folded
}

enum SequenceStyle{
	ant
	block
	flow
}

enum MappingStyle{
	any
	block
	flow
}

struct YamlPointer{
	index int
	line int
	column int
}

struct Event{
	typ EventKind
	start YamlPointer 
	end YamlPointer
	version YamlVersion
	tag []byte
	anchor []byte
	implicit bool
	quoted_implicit bool
}
