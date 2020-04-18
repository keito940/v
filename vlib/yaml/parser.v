module yaml

struct Parser{
	scanner &scanner.Scanner
var:
	tok token.token
}