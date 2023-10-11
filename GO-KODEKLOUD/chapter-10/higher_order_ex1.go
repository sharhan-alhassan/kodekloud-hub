package main

import "fmt"

// Takes an input, add 100 to it and returns an output (of type int)
func addHundred(x int) int {
        return x + 100
}

// A variadic function of input x and output as a function
func partialSum(x ...int) func() {
        sum := 0
        for _, value := range x {
                sum += value
        }
        return func() {
                fmt.Println(addHundred(sum))
        }
}
func main() {
        partial := partialSum(1, 2, 3, 4, 5)
        partial()
}