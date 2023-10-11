package main
import "fmt"

type Circle struct {
	x int
	y int 
	radius float64
	area float64
}

// Take an argument of a Struct instance
func calcArea(c Circle)  {
	const PI float64 = 3.14
	var area float64
	area = (PI * c.radius * c.radius)
	// Asign the area here to the Struct instance's area
	c.area = area
}

func main()  {
	// Create the Struct instance, and initialize it
	c := Circle{x: 5, y:5, radius: 5, area: 0}

	// Pass the Struct instance as argument to calcArea() funtion
	calcArea(c)

	fmt.Printf("%+v", c)
}