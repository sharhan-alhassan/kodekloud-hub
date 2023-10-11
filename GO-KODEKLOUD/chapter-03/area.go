package main
import "fmt"

const PI float64 = 3.14

func main()  {
	var radius float64 = 5.0
	var area float64
	area = PI * radius * radius

	fmt.Println("Aread of circle is: ", area)
	fmt.Printf("Type of area is: %T", area)
}