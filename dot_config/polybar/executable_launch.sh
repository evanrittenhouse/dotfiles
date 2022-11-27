#!/bin/bash

# kill old bars
killall -q polybar

# launch new bar 
echo "----" | tee -a /tmp/polybar1.log
polybar bottom --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_bottom.log & disown
polybar top --config=$HOME/.config/polybar/config.ini 2>&1 | tee -a /tmp/polybar_top.log & disown

echo "Polybar launched..."
