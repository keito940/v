fn test_cstring() {
	w := c'world'
	hlen := C.strlen(c'hello')
	hlen2 := C.strlen('hello')
	wlen := C.strlen(w)
	assert hlen == 5
	assert hlen2 == 5
	assert wlen == 5
}

fn test_cstring_with_zeros() {
	rawbytes := c'\x00username\x00password'
	s := string(rawbytes, 18)
	h := s.bytes().hex()
	assert h == '00757365726e616d650070617373776f7264'
}
