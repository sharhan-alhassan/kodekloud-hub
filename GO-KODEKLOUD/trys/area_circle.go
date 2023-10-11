package main
import "fmt"

// area=pi*r*r
// perimeter=2*pi*r
// circumference=2*r

const PI float64 = 3.142

func area(r float64) float64 {
	return 2 * r *r 
}

func perimeter(r float64) float64 {
	return 2 * PI * r
}

func circ(r float64) float64{
	return 2 * r
}

func main()  {
	var r float64 
	var choice int
	fmt.Println("Enter a radius value: ")
	fmt.Println("Choose one of the numbers: \n 1 - Area \n 2 - Perimeter \n 3 - Circumference")
	fmt.Scanf("%f %f", &r, &choice)
	if (choice == 1) {
		fmt.Println("Area is: ", area(r))
	}
}