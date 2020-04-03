module x64winnt

const (
	machine_invalid = 0xffff
	machine_type = 0x8664
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
