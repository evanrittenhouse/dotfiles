LOCATION=$(which fish)

sudo echo $LOCATION >> /etc/shells

chsh -s $LOCATION
