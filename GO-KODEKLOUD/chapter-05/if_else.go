package main
import "fmt"

func main()  {
	// var fruit string = "banana"
	var fruit string

	fmt.Println("Enter your favorite fruit: ")
	fmt.Scanf("%s", &fruit)

	if (fruit == "banana"){
		fmt.Println("Fruit is banana")
	} else if (fruit == "orange"){
		fmt.Println("Fruit is orange")
	} else {
		fmt.Println("You've chosen your own fruit: ", fruit)
	}
}