// (c) 2019 keito940 All Rights Reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
// Thanks: Nett,tomlc99.

module toml

import (
	time
)

const (
	NULL = 0
)

pub struct Toml{
	pub mut:
		tbl 	&[]Table
		arr		&[]Array
}

fn toml_parse(s string) Toml {
	mut p := new_parser(s)
	return p.data()
}

struct KeyVal{
	name	string
	mut:
		val TOMLVal
}

struct Array{
	name 			string
	value_type 		ArrayType
	mut:
		val 			&[]TOMLVal
		arr 			&[]Array
		tbl				&[]Table

	enum ArrayType{
		integer str muitl_str double time_stamp
	}
}

fn (a Array) val (i int) TOMLVal{
	return a.val[i]
}

fn new_array(name string,val TOMLVal,val_type int){
	return Array{}
}

fn (a Array) array_of_table(s string) ?Table{
	for table in a.tbl.key{
		if s == table.name{
			return table
		}
	}
	return error('Array:$a.name of Table:$a.tbl.name \'s Key:$s is Not Found.')
}

struct Table{
	name		string
	mut:
		key 		&[]KeyVal
		tbl			&[]Table
		arr			&[]Array
}

fn new_table(key_name string,val TOMLVal){
	return Table{name: key_name,key: val}
}

fn (t Table) key(s string) ?KeyVal{
	// Key Search.
	for table in t.key{
		if s == table.name{
			return table.name
		}			
	}
	return error('Key:$s is Not Found.')
}

struct TOMLInt{
	int_type IntType
	mut:
		val 	i64
		str_val	string
	enum IntType{
		demical binary octal hex
	}
}

struct TOMLDouble{
	mut:
		val f64
		str_val string
}

// TOML's Value.
struct TOMLVal{
	mut:
		integer		TOMLInt
		str 		string
		boolean 	bool
		time_stamp	TimeStamp
		arr			Array
}

fn (t TOMLInt) val() i64 {
	return t.val
}

fn (t TOMLInt) str_val() string{
	return t.str_val
}

fn (t TOMLDouble) val() f64{
	return t.val
}

fn (t TOMLDouble) str_val() string{
	return t.str_val
}

struct TimeStamp{
	year		int							
	month  		int
	date		int
	hour		int
	minute		int
	second		int
	millsecond  int
	timezone	TimeZone
}

struct TimeZone {
	hour	int
	minute	int
}

fn (t TimeStamp) val() Time {
	date_data := '$t.year-$t.month-$t.date'
	time_data := '$t.hour:$t.minute:$t.second'
	return parse('$date_data $time_data')
}