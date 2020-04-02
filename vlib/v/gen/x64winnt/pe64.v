module x64winnt

const (
	pe_mag0 = `P`
	pe_mag1 = `E`
	pe_mag2 = 0x00
	pe_mag3 = 0x00
	dos_mag0 = `M`
	dos_mag1 = `Z`
	win_gui_sub_system = 2
	win_cui_sub_system = 3
)

struct Pe64Header {
	machine u16
	number_of_sections int
	time_date_stamp u32
}

struct Object {
	dos_header DosHeader
	is_pe bool
}

struct DosHeader{
	magic u16
	used_bytes u16
	file_size u16
}

struct BigObjectHeader{

}

const (
	machine_invalid = 0xffff
	machine_type = 0x8664 
)