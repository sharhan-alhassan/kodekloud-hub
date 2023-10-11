// Passing by value

package main
import "fmt"

func modify(s string)  {
	s = "world"					// doesn't change, a="hello"
}

func main() {

	a := "hello"
	fmt.Println(a)

	modify(a)
	
	fmt.Println(a)
}

// >>> go run main.go

// hello
// hello