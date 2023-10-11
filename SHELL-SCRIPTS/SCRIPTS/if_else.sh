mission_name=$1

if [ $rocket_status = "failed" ]
then
    rocket-debug $mission_name
elif [ $rocket_status = "success" ]
then   
    echo "Success"
else
    echo "Neither success or failed"
fi 
