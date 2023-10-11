package main
import "fmt"

// create struct template
type Movie struct {
	name   string
	rating float32
}

// function takes two inputs s(string) and r(float)
// and gives an output of a Struct m
func getMovie(s string, r float32) (m Movie) {
	m = Movie{
			name:   s,
			rating: r,
	}
	return
}

func main() {
	fmt.Printf("%+v", getMovie("xyz", 3.5))
}