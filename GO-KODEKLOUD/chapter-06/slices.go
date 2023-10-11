package main
import (
	"fmt"
	"reflect"
)


// normal initialization of slice
func main()  {
	var grades [] int = [] int {12,13,14,15}
	fmt.Println(grades)
}


// short-hand initialization
func main()  {
	grades := [] int {12,13,14,15}
	fmt.Println(grades)
	fmt.Println(reflect.TypeOf(grades))
}