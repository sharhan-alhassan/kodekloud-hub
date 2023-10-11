package main
import "fmt"

func sumNumbers(numbers ...int) int {
	sum := 0
	for _, value := range numbers{
		sum += value
	}
	return sum
}

/* Named Return Values version
func sumNumbers(numbers ...int) (sum int) {
	sum = 0
	for _, value := range numbers{
		sum += value
	}
	return 
} 
*/

func main()  {
	fmt.Println(sumNumbers(0))
	fmt.Println(sumNumbers(10))
	fmt.Println(sumNumbers(10, 20))
	fmt.Println(sumNumbers(10, 20, 30, 40))
}

// >>> go run chapter-08/variadic_function.go