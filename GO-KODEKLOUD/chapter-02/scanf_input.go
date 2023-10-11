package main
import "fmt"

// func main()  {
// 	var name string
// 	// this take a single argument
// 	fmt.Print("Enter your name: ")
// 	fmt.Scanf("%s", &name)
// 	fmt.Println("Hey there,", name)
// }

func main()  {
	var name string
	var is_muggle bool

	fmt.Print("Enter your name & are you muggle: ")

	// This is expecting the input to be two -- separated by single space
	fmt.Scanf("%s, %t", &name, &is_muggle)
	fmt.Print("Name: ", name, "\nMuggle: ", is_muggle)
}