package main
import (
	"fmt"
	"reflect"
)

// short-hand initialization
// for each item in the Array as i

// func main()  {
// 	grades := [4] int {1,2,3,4}
// 	for i := 0; i < len(grades); i++ {
// 		fmt.Println(grades[i])
// 	}
// }


func main()  {
	grades := [4] int {1,2,3,4}

	for index, element := range grades {
		fmt.Println(index, "-->", element)
	}
	fmt.Println(reflect.TypeOf(grades))

}