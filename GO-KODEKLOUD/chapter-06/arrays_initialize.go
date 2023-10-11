package main
import "fmt"

func main()  {
	// normal initialization
	var fruits [3] string = [3] string {"orange", "banana", "apple"}
	fmt.Println(fruits)
	fmt.Println("The length of the Array fruites is: ", len(fruits))

	// short-hand initialization
	var grades [5] int = [5] int {1, 2, 3, 4, 5}
	fmt.Println(grades)

	// Elipse initialization
	names := [...] string {"sharhana", "dada", "hanifa", "kiwam"}
	fmt.Println(names)
}