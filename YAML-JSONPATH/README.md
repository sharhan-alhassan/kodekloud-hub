# JSON PATH

# Syntax
- Json Path is a Query language for json data

- A json path query root element is called with a `$.` sign. The `.` is for the dictionary

- Example of fetching a car's color and a bus's price:

## Table 1.0
```json
// Table 1.0

{
    "car": {
        "color": "blue",
        "price": "$20,000"
    },
    "bus": {
        "color": "green",
        "price": "40,999"
    }
}

// car's color
$.car.color

// bus's price
$.bus.price

```

# JSON PATH -- Lists
- Any output of a json path is in an array ( in a `[]`)

- To fetch elements from a List or Array

## Table 2.0
```json
[
    "book",
    "pen",
    "pencil",
    "erasor"
]

// To get book
$[0]

// To get pencil
$[2]

// To get pencil and erasor
$[2,3]

// To get from book to pencil
$[0:2]
```

# JSON PATH -- Dictionary and Lists 
- Fetch the model of the second wheels of the car 

## Table 3.0
```json
{
    "car": {
        "color": "blue",
        "wheels": [
            {
                "model": "E2353",
                "location": "Wa"
            },
            {
                "model": "G2343",
                "location": "Accra"
            },
            {
                "model": "U3413",
                "location": "Kumasi"
            }
        ]
    }
}

// Solution
$.car.wheels[1].model

```

# JSON PATH -- Criteria or Filter

- It's used to fetch items based on a condition

- Syntax of a filter is `?()`

- Each item in a list, OR for item in items is denoted with `@`

```json

// Example: Fetch all numbers above 3

[
    1,
    2,
    3,
    4,
    5,
    6,
    7
]

// Solution
$[?( @ > 3 )]

// Other operators are:
@ == 3
@ != 3
@ in [1,2,3,4]
@ nin [2,3,4,5]
```

# JSON PATH -- Filter example

```json
// Questin 1. Check which car's wheel location is from Accra and fetch its model

// solution
$.car.wheels[?( @.location == "Accra")].model


// Find Malala in the below list of Noble Prize Winners. 
// Refer to data.json in root directory


// Solution
// 1. $.prizes[?(@.category=="peace")].laureates[?(@.firstname=="Malala")]

// 2. $.prizes[5].laureates[1]
```

## Quiz Link
https://mmumshad.github.io/json-path-quiz/index.html

# JSON PATH -- Wild Cards

- A `*` in a dictionary means any item in the dictionary

- From `Table 1.0`, retrieve all colors of all lorries (both car and bus) from the dictionary

```sh
$.*.color
```

- From `Table 3.0`, retrieve all `models` from wheels in the list
```sh
$[*].model
```

# Samples Questions and Answers -- refer to data.json

```sh
Question 1
Find the first names of all winners of year 2014 in the below list of Noble Prize Winners.

Solution 
$.prizes[?(@.year=="2014")].laureates[*].firstname

Question 2
The first names of all winners in the below list of Noble Prize Winners.

Solution
$.prizes[*].laureates[*].firstname

Question 3
Retreive all the amount's paid to the employee from his payslips data.

Solution
$.employee.payslips[*].amount
```


# JSON PATH -- Kubernetes Use Case

## Steps
1. Identify the `kubectl` command to use. Eg; `kubectl get pods`

2. Familiarize and see what the json output is: Eg; `kubectl get po nginx -o json`

3. For the `JSON PATH` query. Eg; Fetch the image `$.items[0].spec.containers[0].image`. The `$` at the beginning is optional so you can eliminate it

4. Enclose the Query with single quotes and curly brackets `'{..}'`. Eg;
`kubectl get pods -o=jsonpath='{ .items[0].spec.containers[0].image }'`

## Usefuls

- For new line, use `{"\n"}`. Eg;
```sh
`kubectl get nodes -o=jsonpath='{ .items[0].metadata.name }{"\n"}{ items[0].status.capacity.cpu}'`

# Output
master node01
4       4
```

- For tab, use `{"\t"}`
