package main

import "fmt"

func addHundred(x int) {
        fmt.Println(x + 100)
}
func partialSum(add100 func(x int), x ...int) int {
        sum := 0
        for _, value := range x {
                sum += value
        }
        add100(sum)
        return 0
}
func main() {
        partial := partialSum(addHundred, 1, 2, 3)
        fmt.Println(partial)
}