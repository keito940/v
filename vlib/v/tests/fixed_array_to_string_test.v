fn test_fixed_array_to_string() {
	mut a1 := [3]string
	a1[0] = '1'
	a1[1] = '2'
	a1[2] = '3'
	assert '$a1' == "['1', '2', '3']"

	mut a2 := [2]string
	a2[0] = 'a'
	a2[1] = 'b'
	assert '$a2' == "['a', 'b']"

	mut c1 := [3]int
	c1[0] = 1
	c1[1] = 2
	c1[2] = 3
	assert '$c1' == '[1, 2, 3]'

	mut c2 := [3]i16
	c2[0] = 1
	c2[1] = 2
	c2[2] = 3
	assert '$c2' == '[1, 2, 3]'

	mut c3 := [3]i64
	c3[0] = 1
	c3[1] = 2
	c3[2] = 3
	assert '$c3' == '[1, 2, 3]'

	mut c4 := [3]u64
	c4[0] = 1
	c4[1] = 2
	c4[2] = 3
	assert '$c4' == '[1, 2, 3]'

	mut d1 := [3]f64
	d1[0] = 1.1
	d1[1] = 2.2
	d1[2] = 3.3
	assert '$d1' == '[1.1, 2.2, 3.3]'

	mut d2 := [3]f32
	d2[0] = 1.1
	d2[1] = 2.2
	d2[2] = 3.3
	assert '$d2' == '[1.1, 2.2, 3.3]'
}
