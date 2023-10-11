package main
import "fmt"

func studentDetails(student string, subjects ...string) {
	fmt.Println("Hey ", student, ", here are your subjects -")
	// sub := [...]string{""}
	for _, value := range subjects {
		fmt.Printf("%v \n", value)
		// fmt.Println(sub)
		// return sub
		// slice := append(sub, value)
	}
}	

func main()  {
	studentDetails("sharhan", "physics", "maths")
}