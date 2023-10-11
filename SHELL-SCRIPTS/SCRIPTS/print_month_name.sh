# PROBLEM
# Develop a shell script /home/bob/print-month-name.sh that accepts the number of a month as 
# input and prints the name of the respective month. eg ./print-month-name.sh 1 should print J
# anuary and ./print-month-name.sh 5 should print May. Also keep these in mind.
# The script must accept a month number as a command line argument.
# If a month number is not provided as command line argument, the script must exit with 
# the message No month number given.

# The script must not accept a value other than 1 to 12. If not the script must exit with the 
# error Invalid month number given


if [ -n $1 ]
then
  echo "no argument"
else
  echo "argument $1"
fi