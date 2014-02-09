stty -F /dev/ttyUSB0 9600;
echo "f" > /dev/ttyUSB0;
sleep 5;
#echo "c" > /dev/ttyUSB0;
#echo `head -n1 /dev/ttyUSB0& echo -e "c\\r"> /dev/ttyUSB0`;
echo `head -n1 /dev/ttyUSB0& echo -e "c\\r"> /dev/ttyUSB0`;
