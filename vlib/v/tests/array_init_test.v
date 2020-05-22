struct Init {
	len int
}

fn test_array_init() {
	b := [1, 2, 3]
	mut a := []int{cap: b.len}
	a << 1
	'$a, $a.len, $a.cap' == '[1], 1, 3'

	c := Init{len: 3}
	mut d := []string{cap: c.len}
	d << 'aaa'
	d << 'bbb'
	'$d, $d.len, $d.cap' == "['aaa', 'bbb'], 2, 3"
}

fn test_array_init_with_default() {
	a1 := []int{len: 4, init: 2}
	assert '$a1' == '[2, 2, 2, 2]'

	a2 := []int{len: 3, init: 12345}
	assert '$a2' == '[12345, 12345, 12345]'

	b1 := []string{len: 3, init: 'abc'}
	assert '$b1' == "['abc', 'abc', 'abc']"

	b2 := []string{len: 2, init: '111'}
	assert '$b2' == "['111', '111']"
}

fn test_array_init_with_len_no_default() {
	a1 := []int{len: 4}
	assert '$a1' == '[0, 0, 0, 0]'

	a2 := []string{len: 4}
	assert '$a2' == "['', '', '', '']"

	a3 := []bool{len: 3}
	assert '$a3' == '[false, false, false]'
}

fn test_array_int_full_options() {
	println('Test array of int values')

	a := []int{len: 2, cap: 10} // this creates an array with 2 items, initial capacity 10, default value of array type
	println('array a: length: ${a.len}, capacity: ${a.cap}, content: $a')
	assert a.len == 2
	assert a.cap == 10
	assert a.cap >= a.len
	assert a.str() == "[0, 0]"

	b := []int{len: 10, cap: 100, init: 1} // this creates an array with 10 one and initial capacity 100 elements, value given
	_ := b.clone() // discard result variable, sample
	println('array b: length: ${b.len}, capacity: ${b.cap}, content: $b')
	assert b.len == 10
	assert b.cap == 100
	assert b.cap >= b.len
	assert b.str() == "[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]"

	mut c := []int{len: 2, cap: 10, init: 1} // this creates an array with 2 one and initial capacity 10 elements, value given
	_ := c.clone() // discard result variable, sample
	println('array c: length: ${c.len}, capacity: ${c.cap}, content: $c')
	assert c.len == 2
	assert c.cap == 10
	assert c.cap >= c.len
	assert c.str() == "[1, 1]"
	// add some items to the array, to check limits
	c << [3, 4, 5, 6, 7, 8, 9, 10] // add 8 items, from another array
	// update one item, to have the right number in the sequence ...
	c[1] = 2
	println('array c: length: ${c.len}, capacity: ${c.cap}, content now: $c')
	assert c.len == 10
	assert c.cap == 10
	assert c.cap >= c.len
	assert c.str() == "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]"
	// add some more item after initial capacity, to ensure it's expandable
	c << [11, 12, 13, 14, 15, 16]
	println('array c: length: ${c.len}, capacity: ${c.cap}, content now: $c')
	assert c.len == 16
	assert c.cap >= c.len
	assert c.str() == "[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]"
}

fn test_array_string_full_options() {
	println('Test array of string values')

	a := []string{len: 2, cap: 10} // this creates an array with 2 items, initial capacity 10, default value of array type
	println('array a: length: ${a.len}, capacity: ${a.cap}') // ok
	println('array a: length: ${a.len}, capacity: ${a.cap}, content: "$a"')
	assert a.len == 2
	assert a.cap == 10
	assert a.cap >= a.len
	assert a.str() == "['', '']"

	b := []string{len: 10, cap: 100, init: 'b'} // this creates an array with 10 'b', initial capacity 100 elements, value given
	_ := b.clone() // discard result variable, sample
	println('array b: length: ${b.len}, capacity: ${b.cap}') // ok
	println('array b: length: ${b.len}, capacity: ${b.cap}, content: $b')
	assert b.len == 10
	assert b.cap == 100
	assert b.cap >= b.len
	assert b.str() == "['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b']"

	mut c := []string{len: 2, cap: 10, init: 'c'} // this creates an array with 2 'c' and initial capacity 10 elements, value given
	_ := c.clone() // discard result variable, sample
	println('array c: length: ${c.len}, capacity: ${c.cap}, content: $c')
	assert c.len == 2
	assert c.cap == 10
	assert c.cap >= c.len
	assert c.str() == "['c', 'c']"
	// add some items to the array, to check limits
	c << ['c', 'c', 'c', 'c', 'c', 'c', 'c', 'c'] // add 8 items, from another array
	// update some items, to have the right number in the sequence ...
	c[0] = 'a'
	c[1] = 'b'
	println('array c: length: ${c.len}, capacity: ${c.cap}, content now: $c')
	assert c.len == 10
	assert c.cap == 10
	assert c.cap >= c.len
	assert c.str() == "['a', 'b', 'c', 'c', 'c', 'c', 'c', 'c', 'c', 'c']"
	// add some more item after initial capacity, to ensure all is good
	c << ['11', '12', '13', '14', '15', '16']
	// c << ['11', nil, '13', '14', '15', '16'] // check later if/how to handle this ...
	println('array c: length: ${c.len}, capacity: ${c.cap}, content now: $c')
	assert c.len == 16
	assert c.cap >= c.len
	assert c.str() == "['a', 'b', 'c', 'c', 'c', 'c', 'c', 'c', 'c', 'c', '11', '12', '13', '14', '15', '16']"
}
