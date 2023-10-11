package main
import (
	"fmt"
)

func main(){
	var i int = 100
	switch i {
	case 10:
		fmt.Println("i is 10")
	case 100, 200:
		fmt.Println("i is either 100 or 200")
	default:
		fmt.Println("i is neither 0, 100 or 200 ")
	}
}