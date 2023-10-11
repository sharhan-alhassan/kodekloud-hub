package main

import (
        "fmt"
        "strings"
)

func getString(str string) (string, string) {
        return strings.ToLower(str), strings.ToUpper(str)
}

func main() {
        _, lower := getString("BROWSER")
        fmt.Println(lower)
}