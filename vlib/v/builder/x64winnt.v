module builder

import v.parser
import v.pref
import v.gen
import v.gen.x64winnt

pub fn (mut b Builder) build_x64winnt(v_files []string, out_file string) {

}

pub fn (mut b Builder) compile_x64winnt() {
	files := [b.pref.path]
	b.set_module_paths()
	b.bulid_x64winnt(files, b.pref.out_name)
}