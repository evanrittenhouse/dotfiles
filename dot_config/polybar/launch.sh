#!/bin/bash

# kill old bars
killall -q polybar

# launch new bar 
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
