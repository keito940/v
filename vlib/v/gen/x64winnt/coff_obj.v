module x64winnt

#flag -lws2_32

pub struct ImageFileHeader {
	machine u16
	// number of sections.
	numsec u16
	// timedate stamp.
	timedate_s u32
	// pointer of symbol table.
	ptrsymtab u32
	num_symbols u32
	sizeof_optional_header u16
	Characterristics u16
}

pub struct ImageCoffSymbolsHeader {
	num_sym u32
}