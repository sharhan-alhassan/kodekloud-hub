/*
// Example -- Declaring a map with key_type of int and data_type of 
another function which also takes an input of r of data_type float64 
and gives an output of data_type float64
*/

func getFunction(query int) func(r float64) float64 {
	query_to_function := map[int]func(r float64) float64{
		1: calcArea,
		2. calcPerimeter,
		3. calcDiameter
	}
	return query_to_function[query]
}