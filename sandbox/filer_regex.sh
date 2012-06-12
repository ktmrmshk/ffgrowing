F="hogehoge.mov"
STR="ogea"

if [[ "$F" =~ "$STR" ]]; then
	echo "yes"
else
	echo "No"
fi


F="/data/kitamura/kita_12.mov"
G="${F##*/}"
E="${G%.*}"
H="${G##*.}"

echo "$E"
echo "$H"



for F in ./*.mov
do 
	echo $F
done

