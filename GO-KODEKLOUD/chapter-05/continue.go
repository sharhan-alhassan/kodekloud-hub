package main
import "fmt"

func main(){
    for i := 0; i <=4; i++{
        if i == 2{
			// fmt.Println("i = ", i)
            continue           // jump when i==2
        }
		fmt.Println(i)
    }
}

// output
// >> go run chapter-04/continue.go
// 0
// 1
// 3
// 4