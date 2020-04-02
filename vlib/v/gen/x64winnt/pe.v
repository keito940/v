module x64winnt

const (
	pe_mag0 = 'P'
	pe_mag1 = 'E'
	pe_mag2 = '0'
	pe_mag3 = '0'
	dos_mag0 = 'M'
	dos_mag1 = 'Z'
)

struct PEHeader {
	machine u16
	number_of_sections int
	time_date_stamp u32
}

struct DOSHeader{

}

struct BigObjectHeader{

}

const (
	machine_invalid = 0xffff
	machine_type = 0x8664 
)