package main
import "fmt"

func main()  {
	var i int
	var name string
	var flt float64
	var bol bool 

	fmt.Printf("%d", i, "\n")				// output 0
	fmt.Printf("%v", name, "\n")				// output ""
	fmt.Printf("%.2f", flt, "\n")			// output 0.0
	fmt.Printf("%f", bol, "\n")				// output false
}