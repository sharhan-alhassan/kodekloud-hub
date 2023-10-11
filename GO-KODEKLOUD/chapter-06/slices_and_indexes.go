package main
import "fmt"

// modifying a slice index value will eventually change its corrsponding
// value in the parent/underlying Array
func main()  {
	arr := [4] int {10,20,30,40}
	slice := arr[:2]	//10,20,330
	fmt.Println("Before modification of slice")
	fmt.Println("Array: ", arr)
	fmt.Println("Slice: ", slice)
	fmt.Println("After modification of slice")
	slice[0] = 5		// change 10 to 5
	fmt.Println("Array: ", arr)
	fmt.Println("Slice: ", slice)
}

// output
/*
Before modification of slice
Array:  [10 20 30 40]
Slice:  [10 20]
After modification of slice
Array:  [5 20 30 40]
Slice:  [5 20]
*/