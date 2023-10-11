package main
import "fmt"

/*
Example 1
Save the anonymous function in variable x and call it later
*/
func main(){
    x := func(a int, b int) int {
        return a * b
    }

    fmt.Println(x(2, 3))
	fmt.Printf("%T", x)
} 

/*
Example 2.
We dont' even need to save the function in a variable. It's called right after it's
declared
*/
func main(){
    x := func(a int, b int) int {
        return a * b
    }(2,4)

	fmt.Println(x)
} 