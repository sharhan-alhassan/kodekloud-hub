while true
do
    echo "1. shutdown"
    echo "2. restart"
    echo "3. exit menu"
    read -p "Enter you choice: " choice

    if [ $choice -eq 1 ]
    then
        echo "off me"
        exit 1
    elif [ $choice -eq 2 ]
    then
        echo "rebring now"
    elif [ $choice -eq 3 ]
    then
        break
    else
        continue        # start all over if none of the comands are used
    fi
done