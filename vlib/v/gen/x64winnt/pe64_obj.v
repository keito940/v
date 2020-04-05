module x64winnt

#flag -lws2_32
#include <winnt.h>

const (
	machine_invalid = 0xffff
	machine_type = 0x8664
)

struct ImageNtHeaders64 {
	Signature u32
}

struct Pe64Header {
	machine u16
	number_of_sections int
	time_date_stamp u32
}

struct Object {
	dos_header DosHeader
	is_pe bool
}

struct BigObjectHeader{

}

