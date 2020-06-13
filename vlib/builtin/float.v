// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module builtin

import strconv.ftoa

#include <float.h>
// ----- f64 to string functions -----
// str return a f64 as string in scientific notation, auto display digits limit
[inline]
pub fn (d f64) str() string {
	return ftoa.ftoa_64(d)
}

[inline]
pub fn (d any_float) str() string {
	x := f64(d)
	abs_x := f64_abs(x)
	if abs_x >= 0.01 && abs_x < 1.0e16 {
		return ftoa.f64_to_str_l(x)
	} else {
		return ftoa.ftoa_64(x)
	}
}

// return a string of the input f64 in scientific notation with digit_num deciamals displayed, max 17 digits
[inline]
pub fn (x f64) strsci(digit_num int) string {
	mut n_digit := digit_num
	if n_digit < 1 {
		n_digit = 1
	} else if n_digit > 17 {
		n_digit = 17
	}
	return ftoa.f64_to_str(x, n_digit)
}

// return a decimal notation of the input f64
[inline]
pub fn (x f64) strlong() string {
	return ftoa.f64_to_str_l(x)
}

// ----- f32 to string functions -----
// str return a f32 as string in scientific notation, auto display digits limit
[inline]
pub fn (d f32) str() string {
	return ftoa.ftoa_32(d)
}

// return a string of the input f32 in scientific notation with digit_num deciamals displayed, max 8 digits
[inline]
pub fn (x f32) strsci(digit_num int) string {
	mut n_digit := digit_num
	if n_digit < 1 {
		n_digit = 1
	} else if n_digit > 8 {
		n_digit = 8
	}
	return ftoa.f32_to_str(x, n_digit)
}

// return a decimal notation of the input f32
[inline]
pub fn (x f32) strlong() string {
	return ftoa.f32_to_str_l(x)
}

// ----- C functions -----
[inline]
fn f32_abs(a f32) f32 {
	return if a < 0 {
		-a
	} else {
		a
	}
}

[inline]
fn f64_abs(a f64) f64 {
	return if a < 0 {
		-a
	} else {
		a
	}
}


[inline]
fn f32_max(a, b f32) f32 {
	return if a > b {
		a
	} else {
		b
	}
}

[inline]
fn f32_min(a, b f32) f32 {
	return if a < b {
		a
	} else {
		b
	}
}

[inline]
fn f64_max(a, b f64) f64 {
	return if a > b {
		a
	} else {
		b
	}
}

[inline]
fn f64_min(a, b f64) f64 {
	return if a < b {
		a
	} else {
		b
	}
}

[inline]
pub fn (a f32) eq_epsilon(b f32) bool {
	hi := f32_max(f32_abs(a), f32_abs(b))
	delta := f32_abs(a - b)
	if hi > f32(1.0) {
		return delta <= hi * (4 * f32(C.FLT_EPSILON))
	} else {
		return (1 / (4 * f32(C.FLT_EPSILON))) * delta <= hi
	}
}

[inline]
pub fn (a f64) eq_epsilon(b f64) bool {
	hi := f64_max(f64_abs(a), f64_abs(b))
	delta := f64_abs(a - b)
	if hi > 1.0 {
		return delta <= hi * (4 * f64(C.DBL_EPSILON))
	} else {
		return (1 / (4 * f64(C.DBL_EPSILON))) * delta <= hi
	}
}
