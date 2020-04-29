module errors

import v.token

pub enum Reporter {
	scanner
	parser
	checker
	gen
}

pub struct Error {
	message   string
	file_path string
	pos       token.Position
	reporter  Reporter
	backtrace string
}

pub struct Warning {
	message   string
	file_path string
	pos       token.Position
	reporter  Reporter
}
