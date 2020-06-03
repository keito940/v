// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
module gg2

import glm
import gx
import os
import sokol
import sokol.sapp
import sokol.sgl
import sokol.gfx

pub struct Config {
pub:
	width         int
	height        int
	use_ortho     bool
	retina        bool
	resizable     bool
	user_data     voidptr
	font_size     int
	create_window bool
	// window_user_ptr voidptr
	window_title  string
	always_on_top bool
	scale         int
	frame_fn      fn(voidptr)
	bg_color      gx.Color
	on_key_down fn(voidptr)
	event_cb fn(voidptr, voidptr)
}

pub struct GG {
	scale      int // retina = 2 , normal = 1
pub mut:
	width      int
	height     int
	clear_pass C.sg_pass_action
	window     C.sapp_desc
	render_fn  fn()
}

fn init_sokol_window(user_data voidptr) {
	desc := C.sg_desc{
		mtl_device: sapp.metal_get_device()
		mtl_renderpass_descriptor_cb: sapp.metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp.metal_get_drawable
		d3d11_device: sapp.d3d11_get_device()
		d3d11_device_context: sapp.d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp.d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp.d3d11_get_depth_stencil_view
	}
	gfx.setup(&desc)
	sgl_desc := C.sgl_desc_t{}
	sgl.setup(&sgl_desc)
}

fn eventcb(e &C.sapp_event, b voidptr){
	println("EVENT")
}

pub fn new_context(cfg Config) &GG {
	//C.printf('new_context() %p\n', cfg.user_data)
	window := C.sapp_desc{
		user_data: cfg.user_data
		init_userdata_cb: init_sokol_window
		frame_userdata_cb: cfg.frame_fn
		event_userdata_cb: cfg.event_cb //eventcb
		window_title: cfg.window_title.str
		html5_canvas_name: cfg.window_title.str
		width: cfg.width
		height: cfg.height
		//high_dpi: true
	}
	if cfg.use_ortho {}
	else {}
	return &GG{
		width: cfg.width
		height: cfg.height
		window: window
		clear_pass: gfx.create_clear_pass( f32(cfg.bg_color.r) / 255.0, f32(cfg.bg_color.g) / 255.0,
f32(cfg.bg_color.b) / 255.0, 1.0)
		scale: 1 // scale
	}
}

pub fn (gg &GG) run() {
	sapp.run(&gg.window)
}

pub fn (ctx &GG) draw_rect(x, y, w, h f32, c gx.Color) {
	sgl.c4b(c.r, c.g, c.b, 128)
	sgl.begin_quads()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.end()
}

pub fn draw_rect(x, y, w, h f32, c gx.Color) {
	sgl.c4b(c.r, c.g, c.b, 128)
	sgl.begin_quads()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.end()
}

pub fn (gg &GG) draw_empty_rect(x, y, w, h f32, c gx.Color) {
	sgl.c4b(c.r, c.g, c.b, 128)
	sgl.begin_line_strip()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.v2f(x, y)
	sgl.end()
}

pub fn create_image(file string) u32 {
	// println('gg create image "$file"')
	if !os.exists(file) {
		println('gg create image no such file "$file"')
		return u32(0)
	}
	// img := stbi.load(file)
	// img.free()
	return 0 // texture
}

pub fn create_image_from_memory(buf byteptr) u32 {
	// texture := gl.gen_texture()
	// img := stbi.load_from_memory(buf)
	// img.free()
	return 0 // texture
}

pub fn (gg &GG) begin() {
	sgl.defaults()
	sgl.matrix_mode_projection()
	sgl.ortho(0.0, f32(sapp.width()), f32(sapp.height()), 0.0, -1.0, 1.0)
}

pub fn (gg &GG) end() {
	gfx.begin_default_pass(gg.clear_pass, sapp.width(), sapp.height())
	sgl.draw()
	gfx.end_pass()
	gfx.commit()
	wait_events()
}

pub fn (ctx &GG) draw_line(x, y, x2, y2 f32, color gx.Color) {}

fn C.WaitMessage()

pub fn wait_events() {
	unsafe {
		$if macos  {
		# NSEvent *event = [NSApp nextEventMatchingMask:NSEventMaskAny
		# untilDate:[NSDate distantFuture]
		# inMode:NSDefaultRunLoopMode
		# dequeue:YES];
		# [NSApp sendEvent:event];
		}
		$if windows {
			C.WaitMessage()
		}
	}
}
