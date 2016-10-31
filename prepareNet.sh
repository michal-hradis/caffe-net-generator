LAYER_BOTTOM=data
ID=0

while read line
do
    # skip lines starting with #
    if [ "#" == "${line:0:1}" ]
    then
	continue
    fi

    # process the layer file
    STATE=1
    TEXT=''
    for word in $line
    do
	case $STATE in
	    1)  STATE=2
		TYPE=$word
		TEXT=$(cat ./L/$TYPE)
		;;
	    2)  STATE=3
		KEY=$word
		;;
	    3)  STATE=2
		VALUE=$word
		TEXT=$(echo "$TEXT" | sed "s/${KEY}:.*$/$KEY: $VALUE/")
		;;
	esac
    done

    #these layers are not in-place
    if [[ 'CONV PROD' == *$TYPE* ]]
    then
	ID=$(( $ID + 1 ))
    fi


    if [[ 'DROP RELU' == *$TYPE* ]]
    then
	TEXT=`echo "$TEXT" | sed 's/bottom:/bottom: "'$LAYER_BOTTOM'"/'`
	TEXT=`echo "$TEXT" | sed 's/top:/top: "'$LAYER_BOTTOM'"/'`
    else 
	TEXT=`echo "$TEXT" | sed 's/bottom:/bottom: "'$LAYER_BOTTOM'"/'`
	LAYER_BOTTOM=${TYPE}_$ID
	TEXT=`echo "$TEXT" | sed 's/top:/top: "'$LAYER_BOTTOM'"/'`
    fi
    
    TEXT=`echo "$TEXT" | sed 's/name:/name: "'${TYPE}_${ID}'"/'`


    echo "$TEXT"
done
