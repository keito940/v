module x64winnt

#flag -lws2_32

struct ImageFileHeader {
	Machine u16
	NumberOfSections u16
	TimeDateStamp u32
	PointerToSymbolTable u32
	NumberOfSymbols u32
	SizeOfOptionalHeader u16
	Characterristics u16
}