package main
import "fmt"

func main(){
    for i := 0; i <=4; i++{
        if i == 2{
			fmt.Println("i = ", i)
            break           // when i==2 break from the for loop
        }
		fmt.Println(i)
    }
}