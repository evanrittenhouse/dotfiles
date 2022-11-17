#!/bin/bash

# kill old bars
killall -q polybar

# launch new bar 
echo "----" | tee -a /tmp/polybar1.log
polybar mybar --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Polybar launched..."
