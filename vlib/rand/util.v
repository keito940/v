// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module rand

import time

// Commonly used constants across RNGs
const (
	lower_mask = u64(0x00000000ffffffff)
)

// Constants taken from Numerical Recipes
[inline]
fn nr_next(prev u32) u32 {
	return prev * 1664525 + 1013904223
}

// utility function that return the required number of u32s generated from system time
[inline]
pub fn time_seed_array(count int) []u32 {
	mut seed := u32(time.now().unix_time())
	mut seed_data := []u32{cap: count}
	for _ in 0 .. count {
		seed = nr_next(seed)
		seed_data << nr_next(seed)
	}
	return seed_data
}

[inline]
fn time_seed_32() u32 {
	return time_seed_array(1)[0]
}

[inline]
fn time_seed_64() u64 {
	seed_data := time_seed_array(2)
	lower := u64(seed_data[0])
	upper := u64(seed_data[1])
	return lower | (upper << 32)
}
