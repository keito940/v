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
	pe_addr = 0x004
)

pub fn (g mut Gen) generate_pe64_header {

}

pub fn (g mut Gen) generate_pe64_footer {

}