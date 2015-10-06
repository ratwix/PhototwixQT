#!/bin/bash
RES="$(sudo bash -c \"/usr/lib/cups/backend/gutenprint52+usb -B dnpds40 -s 2>&1 | grep Remaining | cut -d : -f 3 | sed -re 's/^[[:space:]].(.*).$/\1/'\")"
echo $RES
