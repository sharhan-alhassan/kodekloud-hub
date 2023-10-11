package main
import "fmt"
/*
0. Create signature function calcSquare()
1. Input parameters -- an Array of int stored in numbers
2. output parameters -- an array of int
3. Create empty Array named squares
4. Iterate over input parameters, numbers -- dumping all indeces(with "_") and take values(v)
5. append square values(v) to squares array
6. Return squares array

In main() function
1. create Array of arguments to be consumed by function calcSquare()
2. Pass all Array elements of nums to calcSquare()
*/

func calcSquare(numbers []int) []int {
	squares := []int{}
	for _, v := range numbers {
		squares = append(squares, v*v)
	}
	return squares

}

func main() {
	nums := [3]int{10, 20, 15}
	fmt.Println(calcSquare(nums[:]))
}