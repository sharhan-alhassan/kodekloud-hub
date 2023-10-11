package main
import "fmt"

func main()  {
	// declare two variables a(type string), and b(type int)
	var a string
	var b int
	var c bool

	// Enter two arguments
	fmt.Print("Enter a string, number & float: ")
	
	// Take the two input arguments and save then in the a and b variables
	count, err := fmt.Scanf("%s %d %t", &a, &b, &c)

	fmt.Println("count : ", count)
	fmt.Println("error: ", err)
	fmt.Println("a: ", a)
	fmt.Println("b: ", b)
	fmt.Println("c: ", c)
}