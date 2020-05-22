module x64winnt
const (
	PE_MAG0 = `P`
	PE_mag1 = `E`
	PE_mag2 = 0x00
	PE_mag3 = 0x00
	WIN_GUI_SUB_SYSTEM = 2
	WIN_CUI_SUB_SYSTEM = 3
	PE_ADDR = 0x004
	BIG_OBJ_MAGIC = 
)

struct Symbol {
	name []byteptr
	value u32
	section_number int
	typ u16
	storage_class u8
	number_of_aux_symbols u8
}

enum SymbolStorageClass{
	invalid = 0xff
	end_of_function = -1
	null = 0
	automatic = 1
}

pub fn (g mut Gen) generate_pe64_header {

}

pub fn (g mut Gen) generate_pe64_footer {

}