// Copyright (c) 2019 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

module vweb

import (
	os
	net
	http
	net.urllib
)

const (
	methods_with_form = ['POST', 'PUT', 'PATCH']
	HEADER_SERVER = 'Server: VWeb\r\n' // TODO add to the headers
	HTTP_404 = 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\n404 Not Found'
	HTTP_500 = 'HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\n\r\n500 Internal Server Error'
	mime_types = {
		'.css': 'text/css; charset=utf-8',
		'.gif': 'image/gif',
		'.htm': 'text/html; charset=utf-8',
		'.html': 'text/html; charset=utf-8',
		'.jpg': 'image/jpeg',
		'.js': 'application/javascript',
		'.wasm': 'application/wasm',
		'.pdf': 'application/pdf',
		'.png': 'image/png',
		'.svg': 'image/svg+xml',
		'.xml': 'text/xml; charset=utf-8'
	}
)

pub struct Context {
	static_files map[string]string
	static_mime_types map[string]string
pub:
	req http.Request
	conn net.Socket
	form map[string]string
	// TODO Response
mut:
	headers string // response headers
}

pub fn (ctx Context) html(html string) {
	//println('HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n$ctx.headers\r\n\r\n$html')
	ctx.conn.write('HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n$ctx.headers\r\n\r\n$html') or { panic(err) }
}

pub fn (ctx Context) text(s string) {
	ctx.conn.write('HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n$ctx.headers\r\n\r\n $s') or { panic(err) }
}

pub fn (ctx Context) json(s string) {
	ctx.conn.write('HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n$ctx.headers\r\n\r\n$s') or { panic(err) }
}

pub fn (ctx Context) redirect(url string) {
	ctx.conn.write('HTTP/1.1 302 Found\r\nLocation: $url\r\n$ctx.headers\r\n\r\n') or { panic(err) }
}

pub fn (ctx Context) not_found(s string) {
	ctx.conn.write(HTTP_404) or { panic(err) }
}

pub fn (ctx mut Context) set_cookie(key, val string) { // TODO support directives, escape cookie value (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)
	//println('Set-Cookie $key=$val')
	ctx.add_header('Set-Cookie', '$key=$val')
}

pub fn (ctx &Context) get_cookie(key string) ?string { // TODO refactor
	cookie_header := ' ' + ctx.get_header('Cookie')
	cookie := if cookie_header.contains(';') {
		cookie_header.find_between(' $key=', ';')
	} else {
		cookie_header.find_between(' $key=', '\r')
	}
	if cookie != '' {
		return cookie.trim_space()
	}
	return error('Cookie not found')
}

fn (ctx mut Context) add_header(key, val string) {
	//println('add_header($key, $val)')
	ctx.headers = ctx.headers +
		if ctx.headers == '' { '$key: $val' } else { '\r\n$key: $val' }
	//println(ctx.headers)
}

fn (ctx &Context) get_header(key string) string {
	return ctx.req.headers[key]
}

//pub fn run<T>(port int) {
pub fn run<T>(app mut T, port int) {
	println('Running vweb app on http://localhost:$port ...')
	l := net.listen(port) or { panic('failed to listen') }
	//mut app := T{}
	app.init()
	for {
		conn := l.accept() or {
			panic('accept() failed')
		}
		//foobar<T>()
		// TODO move this to handle_conn<T>(conn, app)
		first_line:= conn.read_line()
		if first_line == '' {
			conn.write(HTTP_500) or {}
			conn.close() or {}
			return
		}
		// Parse the first line
		// "GET / HTTP/1.1"
		//first_line := s.all_before('\n')
		vals := first_line.split(' ')
		if vals.len < 2 {
			println('no vals for http')
			conn.write(HTTP_500) or {}
			conn.close() or {}
			return
		}
		mut headers := []string
		for _ in 0..30 {
			header := conn.read_line()
			headers << header
			//println('header="$header" len = ' + header.len.str())
			if header.len <= 2 {
				break
			}
		}
		mut action := vals[1][1..].all_before('/')
		if action.contains('?') {
			action = action.all_before('?')
		}
		if action == '' {
			action = 'index'
		}
		req := http.Request{
				headers: http.parse_headers(headers) //s.split_into_lines())
				ws_func: 0
				user_ptr: 0
				method: vals[0]
				url: vals[1]
		}
		$if debug {
			println('req.headers = ')
			println(req.headers)
			println('vweb action = "$action"')
		}
		//mut app := T{
		app.vweb = Context{
			req: req
			conn: conn
			form: map[string]string
			static_files: map[string]string
			static_mime_types: map[string]string
		}
		//}
		if req.method in methods_with_form {
			for {
				line := conn.read_line()
				if line == '' || line == '\r\n' {
					break
				}
				//if line.contains('POST') || line == '' {
					//break
				//}
			}
			line := conn.read_line()
			app.vweb.parse_form(line)
		}
		if vals.len < 2 {
			$if debug {
				println('no vals for http')
			}
			conn.close() or {}
			continue
		}

		// Serve a static file if it's one
		// if app.vweb.handle_static() {
		// 	conn.close()
		// 	continue
		// }

		// Call the right action
		app.$action() or {
			conn.write(HTTP_404) or {}
		}
		conn.close() or {}
	}
}


pub fn foobar<T>() {
}

fn (ctx mut Context) parse_form(s string) {
	if !(ctx.req.method in methods_with_form) {
		return
	}
	//pos := s.index('\r\n\r\n')
	//if pos > -1 {
	mut str_form := s//[pos..s.len]
	str_form = str_form.replace('+', ' ')
	words := str_form.split('&')
	for word in words {
		$if debug {
			println('parse form keyval="$word"')
		}
		keyval := word.trim_space().split('=')
		if keyval.len != 2 { continue }
		key := keyval[0]
		val := urllib.query_unescape(keyval[1]) or {
			continue
		}
		$if debug {
			println('http form "$key" => "$val"')
		}
		ctx.form[key] = val
	}
	//}
}

fn (ctx mut Context) scan_static_directory(directory_path, mount_path string) {
	files := os.ls(directory_path) or { panic(err) }
	if files.len > 0 {
		for file in files {
			mut ext := ''
			mut i := file.len
			mut flag := true
			for i > 0 {
		 		i--
				if flag {
					ext = file[i..i + 1] + ext
				}
				if file[i..i + 1] == '.' {
					flag = false
				}
			}

			// todo: os.is_dir is broken now so we expect that file is dir it has no extension
			// if flag {
			if os.is_dir(file) {
				ctx.scan_static_directory(directory_path + '/' + file, mount_path + '/' + file)
			} else {
				ctx.static_files[mount_path + '/' + file] = directory_path + '/' + file
				ctx.static_mime_types[mount_path + '/' + file] = mime_types[ext]
			}
		}
	}
}

pub fn (ctx mut Context) handle_static(directory_path string) bool {
	ctx.scan_static_directory(directory_path, '')

	static_file := ctx.static_files[ctx.req.url]
	mime_type := ctx.static_mime_types[ctx.req.url]

	if static_file != '' {
		data := os.read_file(static_file) or { return false }
		ctx.conn.write('HTTP/1.1 200 OK\r\nContent-Type: $mime_type\r\n\r\n$data') or { panic(err) }
		return true
	}
	return false
}

pub fn (ctx mut Context) serve_static(url, file_path, mime_type string) {
	ctx.static_files[url] = file_path
	ctx.static_mime_types[url] = mime_type
}
