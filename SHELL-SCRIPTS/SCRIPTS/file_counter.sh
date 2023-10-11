for file in $(ls)
do 
    echo $file -- word count $(cat $file | wc -l)
done
