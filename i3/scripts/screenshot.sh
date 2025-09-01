# Create screenshots folder if it doesn't exist
mkdir -p ~/Pictures/Screenshots
# Determine filename
if [ "$1" = "region" ]; then
    FILE=~/Pictures/Screenshots/region_$(date +%F_%T).png
    maim -s "$FILE"
else
    FILE=~/Pictures/Screenshots/full_$(date +%F_%T).png
    maim "$FILE"
fi
# Copy the actual image to clipboard using CopyQ
copyq copy "image/png" - < "$FILE"
