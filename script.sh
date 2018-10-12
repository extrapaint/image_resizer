#!/bin/bash

# Check for dependancies
# imagemagic, mogrify

# Declare functions
verify_parameters () {
[[ "$1" == "-config" ]] && { echo "The -config parameter will only work if script.txt does not exist."; echo "Either remove the flag and re-run, or delete the file to generate a new one."; exit 1; }
[[ -z "$DESTINATIONPATH" ]] && { echo "DESTINATIONPATH is empty" ; exit 1; }
[[ ! -d "$DESTINATIONPATH" ]] && { echo "DESTINATIONPATH does not exist or is not a directory." ; exit 1; }
[[ -z "$SOURCEPATH" ]] && { echo "SOURCEPATH is empty" ; exit 1; }
[[ ! -d "$SOURCEPATH" ]] && { echo "SOURCEPATH does not exist or is not a directory"; exit 1; }
[[ -z "$RESIZETO" ]] && { echo "RESIZETO is empty" ; exit 1; }
[[ -z "$QUALITY" ]] && { echo "QUALITY is empty" ; exit 1; }
}
resize_images () {
  nice -n "$NICENESS" mogrify -verbose -path $DESTINATIONPATH/ -strip -resize $RESIZETO% -quality $QUALITY $SOURCEPATH/*.jpg
}
create_config_file () {
cat <<'EOF' >> script.txt
# Enter the path for the SOURCE images. This is the path to the originals
SOURCEPATH="/full/path/to/source/images"

# Enter the path to OUTPUT the processed files to. These are the shrunked images
DESTINATIONPATH="/full/path/to/processed/images"

# Enter the amount, in percent, to shrink the image by (OMIT the PERCENT SIGN)
RESIZETO="40"

# Enter the amount, in percent, to reduce the image quality to (OMIT the PERCENT SIGN)
QUALITY="50"

# Enter the niceness amount here if desired, otherwise leave blank
# The value may be from 0 to 19, 19 being the least priority.
NICENESS=""
EOF
if [ "$?" == 0 ]
 then
  echo "Configuration file template successfully created."
 else
  echo "Something went wrong. Open a bug."
fi
}

# The main portion of the script.

if [ -f script.txt ]
 then
  source script.txt
   verify_parameters $1
   resize_images
 else
  if [ "$1" == "-config" ]
   then
    create_config_file
   else
    echo "The file script.txt must be present in the same working directory as the script.sh file."
    echo "You may re-run this script with the -config parameter in order to generate the template file."
  fi
fi


