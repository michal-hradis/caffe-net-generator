while read line
do
  if [ "#" == "${line:0:1}" ]
  then
    continue
  fi

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
  	        TEXT=$(echo "$TEXT" | sed "s#__${KEY}:?[^=]*__#$VALUE#" -r )
  	    ;;
    esac
  done

  TEXT=$(echo "$TEXT" | sed "s/__.*://" | sed "s/__.*__//" | sed "s/__//")

  echo "$TEXT"
done
