package main
import "fmt"

func main()  {
	const name string = "Harry Potter"
	const age int = 34
	const is_muggle bool = true

	fmt.Printf("%v: %T \n", name, name)
	fmt.Printf("%v: %T \n", age, age)
	fmt.Printf("%v: %T \n", is_muggle, is_muggle)
}