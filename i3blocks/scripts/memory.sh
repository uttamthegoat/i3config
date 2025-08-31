#!/bin/sh
# Show RAM usage: Used / Available

mem_info=$(free -h | awk '/^Mem:/ {print $3 " / " $7}')
echo "🧠 $mem_info"