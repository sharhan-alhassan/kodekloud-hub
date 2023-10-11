# Installation

```sh
sudo snap install --classic --channel=version-no/stable go
go version
go help
```

# Run "Hello World"
```go
// hello.go
package main
import "fmt"

func main(){
    fmt.Println("Hello, world")
}
```

```sh
go run hello.go
```

- Every executable package/code must contain the `main package` and `main function`


[installation-reference](https://linuxhint.com/install-go-ubuntu-2/)

- Single line comments `//` and multi-line comments `/* */`

# Data Types
- string
- number --> integer and float
- boolean --> true and false
- array and slices --> 
- maps --> key:value

# Memory Allocation

- Integer -- 4 bytes (32-bit machine) are assigned to it or 8 bytes (64-bit machine)
- Boolean -- 1 byte

# Integers
- unint -- are positive and negative numbers
- int -- only positive numbers

# Variables Declaration + Initialization

- Go is statically typed

- Syntax
```go
var <variable-name> <type> = value

// Examples
// string
var name string = "sharhan"

/// int
var i int = 34

// bool
var b bool = true

// float
var f float64 = 34.23

```

# Short-hand Variables Declaration

```go
// short-hand variables declaration + initialization of same data type
var a, b string = "foo", "bar"

// short-hand variables declaration + initialization of different data type
var (
    a, string = "foo"
    a, int = 5
)

// short-hand variable declaration: You use ":=" and implicitly, GO compiler uses the value type as the real type of the variable. No "var" or explicit "type" assigned
firstname := "hello world"

// The value of firstname is "hello world" which is a "string" and implicitly GO compiler makes the variable firstname as type string

// This looks like dynamically typed

// Thus you can modify a same data type assignment
func main(){
    a := "Lisa"
    a := "Adriana"
    fmt.Println(a)      // output Adriana
}

// However, you can not modify different data type assignment. Meaning a is already declared as type string, so you can't later assign an int to it
func main(){
    a := "Lisa"
    a := 2
    fmt.Println(a)      // output: Error use 2 (type untyped) as type string in assignment
}
```

# Newline character
1. Using `Print` together with `\n`
```go
package main
import fmt

func main(){
    var firstname string = "sharhan"
    var lastname string = "alhassan"
    fmt.Print(firstname, "\n")
    fmt.Print(lastname)
}

// output 
sharhan
alhassan
```

2. Using only `Println` will automatically create newline after each print statement

# Print Formatting (Printf)

- This takes a template and pass values to variables in the template

```go
fmt.Printf("Template string %s" Object arg(s))

```
- Other Format Specifiers

1. %v -- formats the value in a default format

```go
var location string = "kumasi"
fmt.Printf("Nice to see you in, %v", location)
```

2. %d formats decimal integers

```go 
var grades int = 54
fmt.Printf("Marks: %d", grades)
```

```go
Printf -- format specifiers
Verb Description
%v default format
%T type of the value
%d integers
%c character
%q quoted characters/string
%s plain string
%t true or false
%f floating numbers
%.2f floating numbers upto 2 decimal places
```

# Variable Scope

- `Inner blocks` can access variables declared within outer blocks

- However, `outer blocks` cannot access variables declared within inner blocks

```go
{
    // outer block
    {
        // inner block
    }
}
```

- `Local variables` are declared within a functional block and only accesible within the functional block only

- `Global variables` are declared outside any functional block and are accessible within anywhere in a any functional block

```go
package main
import "fmt"

// Global variable "name"
var name string = "Lisa"

func main(){
    // local variable "location"
    var location string = "Accra"
    fmt.Println(name)
}
```

# Zero Values

- If a variable is declared but not initialized with a value, a default value is given to it. This is referred to as `Zero Value`

```go
// If the variable type is bool, it's default value is false
// If the variable type is int, it's default value is 0
// If the variable type is string, it's default value is ""
// If the variable type is float64, it's default value is 0.0

// For pointers, functions, interfaces, maps, et cetera, the value is nil
```

# User Input

- Use the scanner function, a function from fmt package

- `Scanf` takes the value of an input and pass it to a declared variable

```go
package main
import "fmt"

// func main()  {
//	Create a variable "name"
// 	var name string
// 	// this take a single argument
// 	fmt.Prinln("Enter your name: ")

//   	pass the input to the "name" variable
// 	fmt.Scanf("%s", &name)
// 	fmt.Println("Hey there,", name)
// }

func main()  {
	var name string
	var is_muggle bool

	fmt.Print("Enter your name & are you muggle: ")

	// This is expecting the input to be two -- separated by single space
	fmt.Scanf("%s, %t", &name, &is_muggle)
	fmt.Println("Name: ", name, "\nMuggle: ", is_muggle)
}
```

- Scanf returns two values

1. `count`: the number of argument that the function writes to

2. `error`: an error thrown during the execution of the function

```go
package main
import "fmt"

func main()  {
	// declare two variables a(type string), and b(type int)
	var a string
	var b int
	var c bool

	// Enter two arguments
	fmt.Println("Enter a string, number & float: ")
	
	// Take the two input arguments and save then in the a and b variables
	count, err := fmt.Scanf("%s %d %t", &a, &b, &c)

	fmt.Println("count : ", count)
	fmt.Println("error: ", err)
	fmt.Println("a: ", a)
	fmt.Println("b: ", b)
	fmt.Println("c: ", c)
}
```

# Find the Type of variable

- You can find the type of a variable in either two ways

# 1. Using %T
1. The %T format specifier

```go
package main
import "fmt"

func main() {
    var grades int = 42
    var message string = "hello world"
    var isCheck bool = true
    var amount float32 = 5466.54

    fmt.Printf("variable grades = %v is of type %T \n", grades, grades)
    fmt.Printf("variable message = '%v' is of type %T \n", message, message)
    fmt.Printf("variable isCheck = '%v' is of type %T \n", isCheck, isCheck)
    fmt.Printf("variable amount = %v is of type %T \n", amount, amount)
}

>>> go run main.go

variable grades = 42 is of type int
variable message ='hello world' is of type string
variable isCheck = 'true' is of type bool
variable amount = 5466.54 is of type float32
```

# 2. Using reflect.TypeOf
- This TypeOf function comes from the "reflect" package -- `reflect.TypeOf`

```go
package main
import (
    "fmt"
    "reflect")

func main() {
    var grades int = 42
    var message string = "hello world"
    fmt.Printf("variable grades=%v is of type %v \n", grades, reflect.TypeOf(grades))
    fmt.Printf("variable message='%v' is of type %v \n", message, reflect.TypeOf(message))
}

>>> go run main.go
variable grades = 42 is of type int
variable message ='hello world' is of type string 
```

# Converting Between Types

- The process of converting on data type to another is termed as `Type Casting`

- Data types can be converted to other data types, `but this does not guarantee that the value will remain intact.`


```go
// Integer to Float
package main
import "fmt"

func main(){
    var i int = 90
    var f float64 = float64(i)
    fmt.Printf("%.2f\n", f)
}

// Float to Integer
package main
import "fmt"

func main(){
    var f float64 = 34.23
    var i int = int(f)
    fmt.Printf("%v\n", i)
}
```

# strconv package

```go
// 1.0
// Itoa() -- converts integer to string
// returns one value -- string formed with the given integer
package main
import (
    "fmt"
    "strconv"
)

func main(){
    var i int = 34
    var s string = strconv.Itoa(i)      //convert to string
}

// 2.0
// Atoi() -- converts string to integer
// returns two values -- the corresponding integer, error (if any)
package main
import "fmt"

func main(){
    var s string = "200"
    i, err := strconv.Atoi(s)
    fmt.Printf("%v, %T \n", i, i)
    fmt.Printf("%v, %T", err, err)
}

>>> go run main.go
200, int
<nil>, <nil>
```

# Constants

- Are values once initialized cannot be modified

- syntax

```go
constant <constant-name> <data type> = value

const name int = 45
```

# Untyped Constant
- They are not explicitly given a type declaration

```go
// example
const age = 23
const f_name, l_age = "sharhan", 34
```

# Typed Constant
- These are constants typed when you explicitly specify the type

```go
// example 
const name string = "harry potter"
const age int = 34

```
- In `constants`, you have to declare and assign a value to it. The concept of default or zero value does not apply to constants. You can not declare a constant and not assign a value to it

## Note: Short-hand variable (:=)
- The short-hand variable does not apply to `constants`

```go
package main
import "fmt"
func main(){
    const name := "Harry Potter"
    fmt.Println("%v: %T \n", name, name)
}

>>> go run main.go
Error: syntax error: unexpected :=, expecting =
```

# Operators and Workflows
# 5 Types of Operators

```go
// Comparison operations: ==, !=, <, >=, 
- Compare two operands and yield a Boolean value
- Allows values of the same data type for comparisons

```

```go
2. Arithmetic operators: +, -, /, %, ++

3. Assignment operators: =, +=, /=, -=, %=

4. Bitwise operators: &, <<, >>, |, ^

5. Logical operators: &&, ||, !
```

## NB: Always remember to first declare and assign variables or only declare variables before you can use them plainly(without any declaration again)

```go
// example
package main
import "fmt"

var a int = 2
var b int = 2
var name string = "Harry Potter"

func main(){
    fmt.Println("His name is: ", name)
    fmt.Println("His age is: ", a * b)
}
```

# Bitwise Operators

- These are operators that works at the bit level
```go
1. AND -- &
2. OR -- |
3. XOR -- ^: The result of XOR is 1 if the two bits are opposite
4. Right Shift -- >>
5. Left Shift -- <<
```

```go
// This converts the numbers 12 and 25 and AND(&) them
// The results is converted back to bits which results in 8
// 12 = 00001100
// 25 = 00011001
        --------
        00001000 = 8(in decimal)
package main
import "fmt"

func main(){
    var x, y int = 12, 25
    z := x & y
    fmt.Println(z)
}
```

## Bitwise -- XOR
- The result of XOR is 1 if the two bits are opposite

- The result will be ZERO(0) if the two bits are the same

```go
0   0   0   0   1   1   0   0
0   0   0   1   1   0   0   1
-----------------------------
0   0   0   1   0   1   0   1 = 21(in decimal)
```

## Bitwise -- Left Shift (<<)
- It shifts all bits towards left by a certain number of specified bits

```go
// Left shift by 1 bit -- Drop digits from the left and add zeroes to the right
0010 << 1 --> 0100
0010 << 2 --> 1000

// Right shift by 1 bit -- Drop digits from right and add zeros from left
1011 >> 1 --> 0101
1011 >> 3 --> 0001
```

# Control Flow

# If -- If else -- else

```go
package main
import "fmt"

func main()  {
	// var fruit string = "banana"
	var fruit string

	fmt.Println("Enter your favorite fruit: ")
	fmt.Scanf("%s", &fruit)

	if (fruit == "banana"){
		fmt.Println("Fruit is banana")
	} else if (fruit == "orange"){
		fmt.Println("Fruit is orange")
	} else {
		fmt.Println("You've chosen your own fruit: ", fruit)
	}
}
```


# Switch Case

- `Switch case` is similar to if-else, however, we use the value of a `variable` or `expression` to change the control flow of a program via a` multi-way branch`

```go
// syntax

switch expression {
case value_1:
// execute when expression equals to value_1
case value_2:
// execute when expression equals to value_2
default:
// execute when no match is found
}
```

- Each case is the swich block has a differnent name or value referred to as an `identifier`

- In the below case, i=100 is compared with the values of each case

```go
package main
import (
	"fmt"
)

func main(){
	var i int = 100
	switch i {
	case 10:
		fmt.Println("i is 10")
	case 100, 200:
		fmt.Println("i is either 100 or 200")
	default:
		fmt.Println("i is neither 0, 100 or 200 ")
	}
}
```

## "fallthrough" keyword
- The `fallthrough` keyword is used in switch-case to force the execution flow to fall through the successive case block. 
- The case that directly comes after the matching case is also executed

```go
// example
funch main(){
    var i int = 10
    switch i {
        case -3:
            fmt.Println("-3")
        case 10:
            fmt.Println("10")       // prints 10
            fallthrough
        case 20:
            fmt.Println("20")       // prints 20 , ALSO EXECUTED BECUASE OF HE FALLTHROUGH IN THE CASE ABOVE IT
            
        default:
            fmt.Println("default")  // prints default
    }
}

```

# Swictch with Conditions

- `Switch with conditions` allow you to write conditional statements in switches. In this case, you don't supply any `expression` to the switch keyword

- syntax
```go 
switch {
    case condition_1:
    // execute when condition_1 is true
    case condition_2:
    // execute when condition_2 is true
    default:
    // execute when no condition is true
}

// example
func main(){
    a, b int = 10, 20
    switch {
        case a + b == 30 :
            fmt.Println("Equal to 30")          // prints this

        case a+b <= 30:
            fmt.Println("less than or equal to 30")

        default:
            fmt.Println("greater than 30")
    }
}
```

## NB: In switch conditionals, as soon as the program executes a case that is true, it automatically leaves the program and exits. This is a built-in break. You dont' need to explicitly call "break" keyword like in other languages like C and C++


# For Loop
- syntax

```go
for initialization, condition, post {
    // statements
}
```
1. `Initializatoin`: This is optional. Used in setting initial values of variables
2. `Condition`: Required. Set the conditions for the loop
3. `Post`: Optional. Run after each successful execution of the Loop

```go
package main
import "fmt"

func main(){
    for i := 0; i <= 5; i++ {
        fmt.Println(i*i)
    }
}
```

# For Loop -- Infinite loop
- To get a loop that runs and never ends, remove the condition from the syntax abd only use initialization and post


# Break & Continue
## 1. Break 
```go
// Break statement immediately allows the loop to break away from the program execution when the condition of the break statement is true

package main
import "fmt"

func main(){
    for i := 0; i <=4; i++ {
        if i == 2 {
            break           // when i==2 break from the for loop
        }
    }
}
```

## 2. Continue
- Continue statement skips the current iteration of loop and continues with the next iteration



# Arrays, Slices & Maps

- An `Array` is a collection of similar `data elements` stored at `contiguous`(shared) memory location

- In Golang, Arrays are termed as `homogenous` data types because they can store only elements of same data type

```go
array elements: 1       2       3       4
memory address: 200     204     206     208     -- difference of 4 becaues int takes 4bytes of memory 
```

## Key Notes
1. Arrays in Golang are fixed length. Once declared and the size is mentioned, we can no longer change the length of the Array

2. Elements of the Array should be same Data type

3. An Array in Golang has a Pointer that points to the first element in the Array. Since memory is contiguous, we can calculate the address of an element we want to

4. An Array has a property called `length` which denotes the number of elements in an Array. And a property called `capacity` which denotes the number of elements it can contain

# Array Declaration Syntax

```go
var     <array-name>    [<size of the array>]   <data-type>

// Example of Array of 5 integers called grades
var grades [5] int

// Array of 3 strings called fruits
var fruites [3] string
```

# Array Initialization

```go
// Normal initialization
// Values are in {} brackets and prefixed with [array size] and type (int)
// Array values should be less/equal to [array size]
var grades [3] int = [3] int {1, 2, 4}

// Array short-hand initialization
grades := [3] int {4, 5, 6}

// Array initialization with Elipses
grades := [...] int {2, 4, 4, 6}
// With Elipses, Golang implicitly calculates the number/lenght of values in {} and use that as the [size of the array]
```

```go
// Example of Array 3 Initializations
package main
import "fmt"

func main()  {
	// normal initialization
	var fruits [3] string = [3] string {"orange", "banana", "apple"}
	fmt.Println(fruits)
	fmt.Println("The length of the Array fruites is: ", len(fruits))

	// short-hand initialization
	var grades [5] int = [5] int {1, 2, 3, 4, 5}
	fmt.Println(grades)

	// Elipse initialization
	names := [...] string {"sharhana", "dada", "hanifa", "kiwam"}
	fmt.Println(names)
}
```
# len() of Array
- Referes to the number of elements stored in an Array

- The `len()` takes an Array as input and return the size

```go
// example
var fruits [3] string = [3] string {"orange", "banana", "apple"}
	fmt.Println(fruits)
	fmt.Println("The length of the Array fruites is: ", len(fruits))
```

# Array Indexes

- Array Indexes start with 0

```go
var grades [5] int = [5] int {1,2,3,4,5}
// First value with index
grade[0]

// Second value
grade[1]

// Change value at index 0
grade[0] = -1
```

# Looping through an Array
```go
// for each itme in the Array(grades) as i
var grades [4] int = [4] int {1,2,3,4}
for i:=0; i<len(arr); i++ {
    fmt.Println(grades[i])
}
```

# Looping through an Array with "index" and "element" using "range"
```go
// syntax
for index, element := range grades {
    fmt.Println(index, "-->", element)
}
```

# Multidimensional Arrays
- Having Arrays within Arrays
```go
arr := [3][2] int {{2,4}, {4,16}, {8,64}}

// [3] -- reppresents the 3 {} sets 
// [2] -- represents the number of element per each set {}
```

# Slice
```go
- `Slice` is a continuous segment of an existing array

- It provides access to a numbered sequence of elements from that Array

- Slices provides access to parts of an Array in a sequential order

- They are variable typed -- can add/remove elements from 
them

// Major difference b/n Arrays and Slices is that, while Arrays have a specified size, in Slices you don't need to specify the slice size
```

# Components of Slice
```go
// 1. Pointer -- Points to the first element of the Slice

// 2. Length -- The number of elements in the Slice. It's function is len(Array)

// 3. Capacity -- The number of elements in the underlaying Array, counting from the FIRST element in the Slice all the way to the bottom. >It's function is cap(Array). Example below

Array       Slice [1:2]
******      ******
* 10 *      * 20 *
* 20 *      * 30 *
* 30 *      ******
* 40 *      
******      
len=4       len=2
cap=4       cap=3   // The cap() starts from 20 all the way to the bottom in the Slice
```

# Declaring a Slice

```go
// Declaration of Slice is similar to Declaring an Array Except that you dont' need to specify the [size of the slice]

// Normal declaration
var <slice_name> [] <data_type> = [] <data_type> {values}

// short-hand
<slice_name> := []<data_type> {values}

// Example of Slice
grades := [] int {10,20,30}
```

```go
// short-hand initialization
func main()  {
	grades := [] int {12,13,14,15}
	fmt.Println(grades)
	// fmt.Println(reflect.TypeOf(grades))
} 
```

# Creating Slice from an Array
```go
package main
import "fmt"

func main(){
    arr := [4]int{2,3,4,5}

    slice_1 := arr[0:2]
}

// output
// [2,3,4]
```

# Declaring Slice with "make" function

```go
// "make" takes 3 parameters: <data_type>, length and capacity(optional)

// syntax
slice := make([] <data_type>, length, capacity)
```

# Slice and Index Numbers
```go
// Slice is a reference to an underlying Array

// When you create a Slice from an Array, the Slice gets its own numbering with its first element at index 0

// Important Note: When you change the value of index in a Slice, it gets affected in the underlying/original/mother Array as well
```

# Appending to a Slice
```go
// syntax
slice = append(slice_itself, elment_1, element_2)

// slice_itself is the original slice
// element_1 and element_2 are the elements you want append to slice_itself and save the result in slice
```

# Appending Slice to Another Slice
```go 
// syntax
slice = append(slice, anotherSlice...)

// Add the 3 dots ... at the end of the to-be added slice
```

# Copying from a Slice
```go
// syntax: use copy()
// destination slice and src slice must be of same data type
num := copy(dest_slice, src_slice)
```

# Looping through Slices
```go
// Looping through slices same as Arrays

for index, value := range grades {
    fmt.Println(index, "=>", value)
}

// For use case where we don't need the "index" or "value", you can replace it with an underscore

for _, value := range grades {
    fmt.Println(value)
}
```

# Maps
```go
- Maps are unordered collection of key/value pairs

- Names in other languages
PHP -- Associated Arrays
Java -- Hash tables
Python -- Dictionary
```

# Declaring and Initializing Maps
```go
// syntax
var <map_name>  map[<key_data_type>]<value_data_type>

// exmaple: declaring a map with key type of string and value of int
var my_map map[string]int

// Syntax -- Declaring and Initializing a Map 
var <map_name> map[<key_data_type>]<value_data_type> = map[<key_data_type>]<value_data_type>{<key-value-pairs>}

// Syntax -- with short-hand
my_map := map[key_data_type]<value_data_type>{key-value-pairs}

// Example -- Declaring & Initializing a Map
languages := map[string]string{"en": "English", "fr": "French", "ar": "Arabic"}

// Example -- Declaring a map with key_type of int and data_type of a function whic htakes an input of r of data_type float64 and output data_type float64
query_to_func := map[int]func(r float64) float64
```

## Declaring a Map without initializing it with data will have its initial values (zero value) as NIL

# Declaring and Initializing Maps with "make()" Function
```go
// syntax
map_name := make(map[key_data_type]<value_data_type>, <initial_capacity>)   //initial_capacity is optional

// example
func main(){
    codes := make(map[string]int)       // declared but not initialized
}

// With Maps created with "make()" function, you can declare it without initializing with values and populate it later like:
languages["en"] = "English"
```

# Length of Map
```go
// syntax
len(map_name)

// example
len(languages)
```

# Accessing Maps key names
```go
// syntax 
map[key]

// example
fmt.Println(languages["en"])
fmt.Println(languages["fr"])
```

# Getting a Map's Key
```go
// Getting a Map's key returns two values
// 1. The value itself
// 2. A boolean(true or false) whether the Map's key exists or not

// syntax
value, found := map_name[key]

// exmaple
value, found := languages["en"]
```

# Adding new key/value to an existing Map
```go
// syntax
map_name[<new_key>] = <new_value>

// example
languagaes["gr"] = "German"

// NB: Ensure new incoming key/values correlates with the key_data_type and value_data_type
```

# Delete key/value pair of a Map
```go
// syntax
delete(map_name, key_name)

// example
delete(languages, "en")
```

# Iterate(loop) over Maps
```go
// syntax
for key, value := range map_name{
    fmt.Println(key, "-->", value)
}
```

# Truncate a Map
```go
// Truncating a Map means deleting all values in the Map
// They are 2 ways to do that

// Method 1. Iterating over the Map and deleting the key/values
for key, value := range languages {
    delete(languages, key)
}

// Mthod 2. Reinitialize the Map with an Empty map
languages := map[string]string 

// Or
languages = make([string]int)

```

# Functions -- Declaration
```go 
// Syntax -- The syntax is termed as the function signature
func <function_name> (<params>) <return_type> {
    // body of functon
}

// Example of function to add 2 numbers
func addNumbers(a int, b int) int {
    sum := a + b
    return sum
}
```

# Calling/Invoking a Function 
```go
// syntax
<function_name>(<argument(s)>)

// Example
addNumbers(2,3)
```

# Parameters vs Arguments
- `Function parameters` are the names listed in the functions' definition
```go
// a and b are parameters -- specifically as input parameters
// the int before {} is the output parameter
func addNumbers(a int, b int) int{
    return a + b            // This is called the Terminating statement
}
```

- `Function Arguments` are the real values passed into the function
```go
// 2 and 4 are the real arguments
addNumbers(2, 4)

```

## The "return value" must be of same data_type to the "output paramater"

# Returm multiple values in single "return" data
```go
func operation(a int, b int) (int, int){
    sum := a + b
    diff := a - b
    return sum, diff
}

func main(){
    sum, differences := operation(20, 10)
    fmt.Println(sum, difference)
}
```

# Named return values
```go
// This is used to return a value(s) with only "return" keyword

// append the to-be return variables to the output parameter data_type

// Take out the short-hand notation (:=)

// Use only return without any variables with it
func operation(a int, b int)(sum int, diff int){
    sum = a + b
    diff = a -b 
    return
}
```

# Variadic Functions
```go
// These are functions that accept variable number of arguments

// It's passing a varrying number of arguments of the same type as reference in the function signature

// To declare a variadic function, the type of the final parameter is preceeded by an elipsis "..."

// Syntax:
func <func_name>(param_1 type, param_2 type, param_3 ...type)(return_type)

// The last parameter can be called any number of parameters of this type

// NB: The variadic function means, you want to have a parameter that can take in multiple values. Period!

// The values of a variadic parameter are created in a "slice". You need to iterate over the slice to fetch them

// check chapter-08/ for MORE examples
```

# Declare empty Function -- Function without Arguments
```go
// When you specify an output parameter, you must return something
package main
import "fmt"

func f() (int, int){
    return 2, 3
}

func main(){
    a, b = f()
    fmt.Println(a,b)
}
```

# Recursive Functions
```go
// Recursion is a concept where a function calls itself by direct or indirect means

// The function keeps calling itself until it reaches a base case

// It's used to solve a problem where the solution is dependent on the smaller instance of the same problem

// check chapter-09/recursive_factorial.go for more examples

```

# Anonymous Function
```go
// A function that is declared without any named identifier to refer to it

// The function has no name attached to it after "func" keyword

// Example
package main
import "fmt"

func main(){
    x := func(1 int, b int) int {
        return 1 * b
    }
    fmt.Printf(x(2, 3))
}
```

# High Order Functions
```go
// A function that receives a function as an argument or returns a function as an Output

// Use case:
// Calculate the Area, Perimeter and Diameter of a Circle
// Radius is the only requirement for Area, Perimeter, and Diameter calculation

// Syntax:
// A function printResult that takes two inputs
// 1. A radius of type float64 &
// 2. Another function called "calcfunction" that takes a radius(r) of type float64 and output of type float64

func printResult(radius float64, calcFunction func(r float64) float64) {
    result := calcFunction(radius)
    fmt.Println("Results: ", result)
}

```

# Defer Statements
```go
// A Defer statement delays the execution of a function until the surrounding function returns

// The deferred call's arguments are evaluated immediately, but the function call is not executed until the surrounding functon returns

// Example
package main
import "fmt"

func printA(a string){
    fmt.Println(a)
}

func printB(a string){
    fmt.Println(a)
}

func printC(a string){
    fmt.Println(a)
}

func main(){
    printA("An")        // prints first
    defer printB("So")  // waits for the below to print first
    printC("Go")
}

// output
An
Go 
So
```


# ******** Pointers **********
```go
// A pointer is a Variable that points/stores the memory Address of another Variable

// A Pointer is basically an Address

x := 1                  // x varialbe is stored in a specified memory

var ptr *int:= &x       // var ptr pointing to the memory Addr of x

*ptr                    // dereferencing the pointer


// Breakdown: integer pointer named ptr is set to the Address of x


// Pointers point to where the memory is allocated and provide ways to find or even
// change the value located at the memory location
```

# Address and Dereference operators

# Address
```go
`& operator` -- The memory address of a variable can be obtained by preceeding the name of the variable with an ampersand sign (&), also know as `address operator`

`* operator` -- It is known as the `dereference operator`. When placed before an address(or pointer), it returns the value of that address

// x := 77         --memory address: 0x0301    --meory: 77
// &x = 0x0301
// *0x0301 = 77
& gives the memory address of the variable
* gives the value of the memory address
```

# Declaring Pointers
```go
// Syntax
var <pointer_name>  *<data_type>

// Don't confuse the * as the dereference property
// data_type of the variable whose address we want to store

// 1. Example -- int pointer
var ptr_i *int

// 2. String pointer
var ptr_s *string
```

# Initialize a Pointer
```go
// Syntax 1
var <pointer_name> *<data_type_of_variable_whose_memory_address_we_want_to_store> = &<variable_name>

// Syntax 2
// In this syntax, the <data_type> of the variable is omitted and internally determine by Go
// using the &<variable_name>
var <pointer_name> = &<variable_name>

// Syntax 3. 
// Using short-hand operator -- omit "var" and "data_type"
<pointer_name> := &<variable_name>

// Taking a pointer as an Argument in a function
func take_pointer(s *int){
    fmt.Println(s)
}

func main(){
    var number int = 4
    take_pointer(number))
}
```

# Initializing Pointers With All 3 Syntaxes
```go
package main
import "fmt"

func main() {
    
    // syntax 1
    s := "hello"
    var b *string = &s
    fmt.Println(b)

    // syntax 2
    var a = &s
    fmt.Println(a)

    // syntax 3
    c := &s
    fmt.Println(c)
}
>>> go run main.go
0xc000010230
0xc000010230
0xc000010230
```

# Dereferencing a Pointer
```go
// Dereferencing a Pointer means, geetting the value of the memory address stored by the Pointer

// syntax
*<pointer_name>

// dereference the variable  pass a new value to the pointer
*<pointer_name> = <new_value_name>

s := "hello"            // store "hello" in s
ptr := &s               // store the address of s in ptr
*ptr = "world"          // dereference ptr and pass new value to the pointer -- world
```

# Two ways of passing arguments to a function
```go
1. Passing by value
2. Passing by reference
```
# Passing by Value in Function
```go
// Function is called by directly passing the value of the variable as an argument

// The parameter is copied into another location of your memory 

// So when accessing or modifying the variable within your function, only the copy is access or modified, and the original value is never modified

// Example

```

# Passing by Reference in Functions
```go
// In a call by reference/pointer, the address of the variable is passed into the function call as the actual parameter

// All the operations in the function are performed on the value stored at the address of the actual parameters

// Hence the modified value gets stored at the same address

// Example: Takes the address of an int as an argument

// Using this syntax of pointer initialization: var ptr *int = &number

// Simple: func add() says, Pass me the address(pointer) of the argument
func add(a *int) int{
    // Change value of the address to 3
    *a = 3
    // Change the value of the address "a" to 3 and add 10 to it
    y = *a + 10
    return y
}

func main(){
    number := 2
    add(&number)        // pass the address of number to add() function
}
```

# Structs, Methods & Interfaces

# Struct Introduction
```go
// 1. It is a user-defined data type

// 2. It is a structure of data element

// 3. A convenient way of grouping several data elements together

// 4. Provides a way to reference a series of grouped values together through a SINGLE VARIABLE name. 

// 5. You can access different data fields of possibley different data types to be stored and accessed from a single variable name

```

# Declaring Struct
```go
// An Empty Struct is just like a template

// syntax
type <struct_name> struct {
    // list of fields
}

// Example of Struct
type Circle struct {
    x float64
    y float64
}

// Example of Struct 
type Student struct {
    name string
    rollNo int
    marks []int
    grades map[string]int
}
```

# Struct Initialization -- Syntax 1
```go
// Initializating a struct is like using a data_type created by a user, hence the name user-defined data_type

// Syntax 
var <variable_name> <struct_name>

// Example
var s Student       

// This creates a local instance of the Struct "Student" defined above with zero
// values to all the fields defined in the Struct

// Use "%+v" formatter passed with the initialized struct instance to see the struct values

// Full Example
package main
import "fmt"

type Student struct{
    name string
    rollNo int
    marks []int
    grades map[string]int
}

func main(){
    var s Student  
    fmt.Printf("%+v", s)
}
```

# Struct Initialization -- Syntax 2
```go
// Syntax
<variable_name> := new(<struct_name>)

// Example
st := new(Student)

// Full Example
...
func main(){
    st := new(Student)  
    fmt.Printf("%+v", st)
}
...
```

# Declare and Initialize a Struct instance
```go
// Declare and use a values in the struct instance -- Remove the "new" keyword
// Syntax:
<variable_name> := <struct_name> {
    <field_name>: <value>
}

// Exmaple
st := Student {
    name: "Joe",
    rollNo: 12
}

// NB: NOT RECOMMENDED 
// You can declare and pass the fields values to the Struct instance according to how they appear in the template. You can pass the values, not the keys. Example
st := Student {"Joe", 12}       // values of name(string) first, then rollNo(int) next
```

# Accessing Struct Fields
```go
// Access fields of a Struct by using "." operator
<variable_name>.<field_name>

// Example
func main(){
    var st Student
    st.name = "sharhan"
    st.rollNo = 9
    fmt.Printf("%+v", st)
}
```

# Passing Structs to Functions
```go
// refer to chapter-13/pass_structs_to_funcs.go
```

# Comparing Structs
```go
// You can compare Structs to see of they are of the same Type and Value

// You can use Go == and != to test for equality

// Two instances of the same Struct template is equal in Type

// Two instances of two different Struct templates aren't the same
```

# Methods
```go
// A method is similar to a function 

// A method augments a function by adding an extra parameter section immediately after the "func" keyword that accepts a single argument

// This argument is called a "receiver"

// Syntax
func (<receiver>) <method_name>(<parameters>) <return_params> {
    //code 
}

// The "receiver" is associated with the "method" 

// A "METHOD" is a function that has a defined receiver

// Example
// Here, any instance of the Circle struct will have a method area() available to them
func (c Circle) area() float64{
    // code 
}

// Full Example
// refer to chapter-14/method.go

```

# Interfaces
```go
```
