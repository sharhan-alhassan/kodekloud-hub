package main
import "fmt"

// 1000 = 8
// 1000 >> 1 = 0100(4)
// 1000 << 1 = 
func main()  {
	var x int = 8
	z := x << 1
	fmt.Println(z)
}