# Introduction
# Rocket Launch Sequenc
```go
1. Start Auxilliary Power
2. Swictch to Internal Power
3. Auto Sequence Start
4. Main Engine Start
5. Lift off
```

# Variables
```sh
# 1. A Variable always has a dollar sign before its name
$mission_name

# 2. However, while setting the value of the Variable, you don't use the dollar sign
mission_name=lunar-mission

# 3. Variables can contain alpha-numerics and not "-" in-between
mission_name    # correct
missoin-name    # incorrect

# 4. You can use a Variable to store the output of another command. Use $()
rocket_status=$(rocket-status $rocket_name)
echo"Status of rocke: " $rocket_status

# 5. You can pass a Variable to with ${} if the variable is used with other letters
file_name="create-file"
cp $file_name ${file_name}_bkp
```

# Command Line Arguments
## How to Pass Arguments from Command Line to a Script
- Say we have a script 

```sh
mission_name=lunar-mission

mkdir $mission_name
rocket-add $mission_name
rocket-start-pwer $mission_name
```
- We want to pass the "mission_name" argument from command line to the script without editing it from the script.

```sh
# In command line
create-and-launch lunar-mission

# Inside script
mission_name=$1
```

- That's where `Command Line Arguments` come in

```sh
# 1. Commands on the Terminal can be accessed from numbers prefixed with $ sign

# 2. First command is $0, second command is $1, third command $3

# Example
create-and-launch lunar-mission

# create-and-launch argument can be accessed from $0
# lunar-mission can be accessed from $1
```

# Read Inputs

- Prompting the user for an input. When the user types in you can take the value as a variable for the input (eg; another script)

```sh
# The keyword "read" is used to take input

# You can used extra keyword "-p" for prompt to send a message about what the input should be 

read -p "Enter mission name:" mission_name

# The input value is stored in mission_name
```

# Arithmetic Operations
# Method 1: Using "expr" commad

```sh
- You can perfomr Arithmetic operations with `expr` keyword
- There must be strict adherence of space b/n the operator the two numbers
# Addition
expr 6 + 4
9
# subtraction
expr 4 - 2 
2
# multiplication: with rare exception, there must be an escape backward slack for * because it's also regex operator
expr 6 \* 3
2
```

# Arithmetic Operations. Method 2: Double paranthenses

```sh
- You can perform arithmetic operations within a double parantheses prefixed with dollar `$(( ))`

- NB: Arithmetic operations done with `$(( ))` can have its results retrieved with an `echo`. Eg 
echo $(( 2 + 5 ))
7

- Note: Results of Arithmetic operations give decimal numbers and not floats. Thus 10/3 gives 3

- To see floating point results, pipe the output to `bc -l`, basic calculator
echo $(( 10/3)) | bc -l
3.33333
```

# Conditional Logic
```sh
# Syntax
if [ <<condition>> ]
then
    "do something"
elif [ <<condition>> ]
then
    "else do something"
else
    "do something if none of the above
fi

```

# Conditional Operators
```sh
# 1. Single Curly Brackets
[ STRING1 = STRING2 ]

- There must be space after the first curly bracket "[ ", a space before and after the " = ", and a space before the closing curly bracket " ]"

- The "=" operator is only to be used to compare strings

- For numbers comparison, use "-eq -ne -gt -lt"

# 2. Double Curly Brackets
[[ STRING1 = STRING2 ]]

- Double brackets are used to make complex comparisons like matching patterns and using expressions

- Example
[[ "abcd" = *bc* ]]             # if first abcd contains bc (true)
[[ "abc" = ab[cd] ]]            # if 3rd character of first abc is c or d (true)
[[ "abe" = "ab[cd]" ]]          # if 3rd character of first abe is c or d (false)
```

# AND "&&" and OR"||" Operators
```sh
# Syntax for AND
[ COND1 ] && [ COND2 ]

- Use the double ampersand "&&" sign

# Syntax for OR
[ COND1 ] || [ COND2 ]

```

# File-level Operators
```sh
[ -e FILE ]             # IF FILE EXIISTS
[ -d FILE ]             # IF FILE EXISTS AND IS A DIRECTORY
[ -s FILE ]             # IF FILE EXISTS AND HAS SIZE GREATER THAN 0
[ -x FILE ]             # IF FILE IS EXECUTABLE
[ -w FILE ]             # IF FILE IS WRITABLE
[ -z ARG  ]             # ARG IS NULL AND DOES EXISTS  -- if true, meaning no argument is provided
[ -n ARG  ]             # ARG IS NOT NULL AND DOES EXISTS

[ -z $1 ]  -- You can use to check if a command argument is provided or not to a scipt. 
```

# Command Substitution "$()" and Brace Parameter Expansion "${}"
```sh
# Command substitution
- The output of a command can be substituted into `$()`
- Use it when you want to capture the command result written to stdout.
# Example
var_date=$(date) && echo $var_date
Ben 31 E-K 2022 17:20:07 GMT

# Brace Parameter Expansion
- To join together a variable output with another value, use `${}`
# Example
price=5
echo "{price}USD"
5USD
```

# Loops -- For
# Syntax

```sh
for item in <list-of-items>     # List of items separated by single spaces
do
    "do something"
done
```
# For Loops -- input from file
```sh
for item in $(cat missions.txt)
do
    echo "$item"
done
```

# For Loops -- iterate over range of numbers
```sh
for mission in {0...100}
do 
    echo "mission-$mission
done
```

# For Loops -- Standing programming loops
```sh
for mission in (( mission=0; mission <= 100; mission++ ))
do
    echo "mission-$mission"
done
```

# While Loops
```sh
# It executes the loop as long as the condition is true

# Syntax
while [ condition ]
do
    "do something"
done
```

# Continue statement
```sh
# continue statement takes you back to the beginning of the loop if none of the specified conditions are met

# Example
while true
do
    echo "1. shutdown"
    echo "2. restart"
    echo "3. exit menu"
    read -p "Enter you choice: " choice

    if [ $choice -eq 1 ]
    then
        shutdown now
    elif [ $choice -eq 2 ]
    then
        restart now
    elif [ $choice -eq 3 ]
    then
        break
    else
        continue
    fi
done
```

# Case Statements
```sh
# Case statements takes the value and compare with all inputs passed
# Each case closes with double ";;"
 Example
while true
do
    echo "1. shutdown"
    echo "2. restart"
    echo "3. exit menu"
    read -p "Enter you choice: " choice

    case $choice in
        1) "off me" ;;
        2) "rebring me" ;;
        3) break ;;
        4) continue ;;
    esac
done
```

# Shebang
```sh
# An expression like the below will only run on bash shells or manually run with -- bash counter.sh
for m in {2..100}
do
    echo $m
    sleep 1
done 

# The quick fix is to append #!/bin/bash to all scripts to make automatically use
# bash shell without you specifying it on the cmd
```

# Exit Codes
```sh
# The Exit code of the most recent command is stored in $?
# exit code 0 is success
# exit code of greater than 0 is failure

# If you dont' set the exit of a command anytime it runs, the script will automatically set it to zero(0). So always use exit codes in shell scripts
```

# Functions
```sh
# Syntax
function function_name(){
    ...
}

# function call
function_name argument1

# Use return with exit codes instead of "exit with code" in functions. In that way, the function only exits from the argument that the function is running and proceed to other arguments

# Take outputs of a function()
function add(){
    echo $(( $1 + $2 ))
}

sum=$( add 3 4 )
```




# [Course-Github](https://github.com/kodekloudhub/shell-scripting-for-beginners-course)
