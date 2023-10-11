package main
import "fmt"

func main()  {
	s := "hello"						// set var s to "hello"
	fmt.Printf("%T, %v \n", s, s)

	ptr_s := &s							// create pointer to store memory addr of s
	fmt.Println("Memory Address of:", s, " is", ptr_s)

	*ptr_s = "world"					// dereference and change value of s to "world"
	fmt.Println("Memory Address of:", s, " is", ptr_s)
}