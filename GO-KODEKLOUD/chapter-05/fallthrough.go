
package main
import "fmt"

// example
func main(){
    var i int = 10
    switch i {
        case -3:
            fmt.Println("-3")
        case 10:
            fmt.Println("10")       // prints 10
            fallthrough
        case 20:
            fmt.Println("20")       // prints 20
            fallthrough
        default:
            fmt.Println("default")  // prints default
    }
}
