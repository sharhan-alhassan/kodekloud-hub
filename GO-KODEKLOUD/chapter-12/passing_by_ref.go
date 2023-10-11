package main
import "fmt"
>>> go run main.go
func main() {
}
hello
world
a := "hello"
fmt.Println(a)
modify(&a)
fmt.Println(a)
func modify(s *string) {
}
*s = "world