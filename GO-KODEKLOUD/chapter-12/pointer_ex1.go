package main
import "fmt"

func main() {
	y := [3]int{10, 20, 30}
	py := &y
	fmt.Printf("%T %v \n", py, *py)
}