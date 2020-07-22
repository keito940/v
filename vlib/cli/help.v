module cli

import term
import strings

const (
	base_indent_len = 2
	min_description_indent_len = 20
	spacing = 2
)

fn help_flag(with_abbrev bool) Flag {
	return Flag{
		flag: .bool,
		name: 'help',
		abbrev: if with_abbrev { 'h' } else { '' },
		description: 'Prints help information',
	}
}

fn help_cmd() Command {
	return Command{
		name: 'help',
		description: 'Prints help information',
		execute: help_func,
	}
}

fn help_func(help_cmd Command) {
	cmd := help_cmd.parent
	full_name := cmd.full_name()

	mut help := ''
	help += 'Usage: ${full_name}'
	if cmd.flags.len > 0 { help += ' [FLAGS]'}
	if cmd.commands.len > 0 { help += ' [COMMANDS]'}
	help += '\n\n'

	if cmd.description != '' {
		help += '${cmd.description}\n\n'
	}

	mut abbrev_len := 0
	mut name_len := min_description_indent_len
	for flag in cmd.flags {
		abbrev_len = max(abbrev_len, flag.abbrev.len + spacing + 1) // + 1 for '-' in front
		name_len = max(name_len, abbrev_len + flag.name.len + spacing + 2) // + 2 for '--' in front
	}
	for command in cmd.commands {
		name_len = max(name_len, command.name.len + spacing)
	}

	if cmd.flags.len > 0 {
		help += 'Flags:\n'
		for flag in cmd.flags {
			mut flag_name := ''
			if flag.abbrev != '' {
				abbrev_indent := ' '.repeat(abbrev_len - flag.abbrev.len - 1) // - 1 for '-' in front
				flag_name = '-${flag.abbrev}${abbrev_indent}--${flag.name}'
			} else {
				abbrev_indent := ' '.repeat(abbrev_len)
				flag_name = '${abbrev_indent}--${flag.name}'
			}
			mut required := ''
			if flag.required {
				required = ' (required)'
			}

			base_indent := ' '.repeat(base_indent_len)
			description_indent := ' '.repeat(name_len - flag_name.len)
			help += '${base_indent}${flag_name}${description_indent}' +
				pretty_description(flag.description + required, base_indent_len + name_len) + '\n'
		}
		help += '\n'
	}
	if cmd.commands.len > 0 {
		help += 'Commands:\n'
		for command in cmd.commands {
			base_indent := ' '.repeat(base_indent_len)
			description_indent := ' '.repeat(name_len - command.name.len)

			help += '${base_indent}${command.name}${description_indent}' +
				pretty_description(command.description, name_len) + '\n'
		}
		help += '\n'
	}

	print(help)
}

// pretty_description resizes description text depending on terminal width.
// Essentially, smart wrap-around
fn pretty_description(s string, indent_len int) string {
	width, _ := term.get_terminal_size()
	// Don't prettify if the terminal is that small, it won't be pretty anyway.
  if indent_len > width {
		return s
	}
	indent := ' '.repeat(indent_len)
	chars_per_line := width - indent_len
	// Give us enough room, better a little bigger than smaller
	mut acc := strings.new_builder(((s.len / chars_per_line) + 1) * (width + 1))

	for k, line in s.split('\n') {
		if k != 0 { acc.write('\n${indent}') }
		mut i := chars_per_line - 2
		mut j := 0
		for ; i < line.len; i += chars_per_line - 2 {
			for line.str[i] != ` ` { i-- }
			// indent was already done the first iteration
			if j != 0 { acc.write(indent) }
			acc.writeln(line[j..i].trim_space())
			j = i
		}
		// We need this even though it should never happen
		if j != 0 {
			acc.write(indent)
		}
		acc.write(line[j..].trim_space())
	}
	return acc.str()
}

fn max(a, b int) int {
	return if a > b {a} else {b}
}
