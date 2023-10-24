bwMax=79
speed=100
srcRemPortSpeed=20
destRemPortSpeed=20


if \
	[ $bwMax -ge $((speed * 80 / 100)) ] \
	&& \
	[ $srcRemPortSpeed -ge $((speed * 20 / 100)) ] \
	&& \
	[ $destRemPortSpeed -ge $((speed * 20 / 100)) ]
then
	echo "True"
else
	echo "False"
fi

