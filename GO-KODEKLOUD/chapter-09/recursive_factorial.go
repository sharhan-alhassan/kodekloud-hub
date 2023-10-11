package main
import "fmt"

func factorial(n int) int {
	// base function
	if n == 1{
		return 1
	}
	return n * factorial(n - 1)
}

func main()  {
	n := 4
	result := factorial(n)
	fmt.Println("Factorial of ", n, " is :", result)
}

/* 
// Explanation
1. First you call the function with n:=3
	factorial(4)

2. If n!=1, run line 9
	return 4 * factorial(3)	= 24

3. if n is still !=1, run line 9 again
		return 3 * factorial(2)	= 6

4. if n is finally ==1, then return and exit
			return 2 * factorial(1)	= 2

*/