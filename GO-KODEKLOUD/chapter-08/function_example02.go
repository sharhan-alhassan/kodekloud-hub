package main
import "fmt"

func printStrings(names ...string) (names_c []string) {
    names_c := []string {}
        for _, value := range names {
                names_c = append(names_c, strings.ToUpper(value))
        }
        return
}

func main() {
        result := printStrings("Joe", "Monica", "Gunther")
        fmt.Println(result)
}