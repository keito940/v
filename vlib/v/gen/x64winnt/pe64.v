module x64winnt
const (
	pe_mag0 = `P`
	pe_mag1 = `E`
	pe_mag2 = 0x00
	pe_mag3 = 0x00
	win_gui_sub_system = 2
	win_cui_sub_system = 3
	pe_addr = 0x004
	big_obj_magic = 
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