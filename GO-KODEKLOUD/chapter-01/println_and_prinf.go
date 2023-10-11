// Golang program to show the uses
// of Printf and Println function

// Printf formats according to a specified format specifier but Println uses the default formats for its operands.

package main

import "fmt"

func main() {
	m, n, p := 15, 25, 40

	fmt.Println(
		"(m + n = p) :", m, "+", n, "=", p,
	)

	fmt.Printf(
		"(m + n = p) : %d + %d = %d\n", m, n, p,
	)
}

Output:

(m + n = p) : 15 + 25 = 40
(m + n = p) : 15 + 25 = 40