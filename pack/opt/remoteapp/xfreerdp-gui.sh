  #!/bin/bash


  #####################################################################################
  #### FEDERAL UNIVERSITY OF SANTA CATARINA -- UFSC
  #### Prof. Wyllian Bezerra da Silva


  #####################################################################################
  #### Dependencies: freerdp-x11 gawk x11-utils yad zenity

  string=""
  if ! hash xfreerdp 2>/dev/null; then
      string="\nfreerdp-x11"
  fi
  if ! hash awk 2>/dev/null; then
      string="\ngawk" 
  fi
  if ! hash xdpyinfo 2>/dev/null; then
      string="${string}\nx11-utils"
  fi
  if ! hash yad 2>/dev/null; then
      string="${string}\nyad"
  fi
  if [ -n "$string" ]; then
    if hash amixer 2>/dev/null; then
      amixer set Master 80% > /dev/null 2>&1; 
    else
      pactl set-sink-volume 0 80%
    fi
    if hash speaker-test 2>/dev/null; then
      ((speaker-test -t sine -f 880 > /dev/null 2>&1)& pid=$!; sleep 0.2s; kill -9 $pid) > /dev/null 2>&1 
    else 
      if hash play 2>/dev/null; then
        play -n synth 0.1 sin 880 > /dev/null 2>&1 
      else
        cat /dev/urandom | tr -dc '0-9' | fold -w 32 | sed 60q | aplay -r 9000 > /dev/null 2>&1
      fi
    fi
    (zenity --info --title="Requirements" --width=300 --text="You need to install this(ese) package(s):
    <b>$string</b>
    ") > /dev/null 2>&1 
    exit
  fi
  #####################################################################################
  #### Get informations
  dim=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
  wxh1=$(echo $dim | sed -r 's/x.*//')"x"$(echo $dim | sed -r 's/.*x//')
  wxh2=$(($(echo $dim | sed -r 's/x.*//')-70))"x"$(($(echo $dim | sed -r 's/.*x//')-70))

  while true
  do

    LOGIN=
    PASSWORD=
    DOMAIN=
    COMPUTER=
    GATEWAY=
    BPP=  
    OPTIONS=  
    [ -n "$USER" ] && until xdotool search "xfreerdp-gui" windowactivate key Right Tab 2>/dev/null ; do sleep 0.03; done &
      FORMULARY=$(yad --center --width=380 \
          --window-icon="gtk-execute" --image="debian-logo" --item-separator=","                                              \
          --title "xfreerdp-gui"                                                                                              \
          --form                                                                                                              \
          --field="Computer" $COMPUTER "Computer Name"                                                               \
          --field="Username" $LOGIN "User Name"                                                                            \
          --field="Password ":H $PASSWORD ""                                                                                  \
          --field="Gateway":CBE $GATEWAY "remoteapp-qd.resourcepro.com.cn,remoteapp-jn.resourcepro.com.cn：8443,remoteapp-hd.resourcepro.com.cn"                \
          --field="Domain" $DOMAIN "resourcepro0"                                                                            \
          --field="BPP":CBE $BPP "8,24,16,32,"                                                                                  \
          --field="Other Options" $OPTIONS "/multimon /video /gdi:hw /gfx-h264:avc444 +gfx-progressive /sound /cert:ignore"                                                                                 \
          --button="Cancel":1 --button="Connect":0)
      [ $? != 0 ] && exit
      COMPUTER=$(echo $FORMULARY   | awk -F '|' '{ print $1 }')
      LOGIN=$(echo $FORMULARY      | awk -F '|' '{ print $2 }')
      PASSWORD=$(echo $FORMULARY   | awk -F '|' '{ print $3 }')
      GATEWAY=$(echo $FORMULARY    | awk -F '|' '{ print $4 }')
      DOMAIN=$(echo $FORMULARY     | awk -F '|' '{ print $5 }')
      BPP=$(echo $FORMULARY        | awk -F '|' '{ print $6 }')
      OPTIONS=$(echo $FORMULARY    | awk -F '|' '{ print $7 }')
        
      RES=$(xfreerdp                            \
                      /v:"$COMPUTER"            \
                      /u:"$LOGIN"               \
                      /p:"$PASSWORD"            \
                      /g:"$GATEWAY"             \
					  /d:"$DOMAIN"              \
                      /bpp:$BPP                 \
                      $OPTIONS                 )    
      echo $RES | grep -q "Authentication failure" &&                                                  \
      yad --center --image="error" --window-icon="error" --title "Authentication failure"              \
      --text="<b>Could not authenticate to computer\!</b>\n\n<i>Please check your password.</i>"         \
        --text-align=center --width=320 --button=gtk-ok --buttons-layout=spread && continue 
      echo $RES | grep -q "connection failure" &&                                                      \
      yad --center --image="error" --window-icon="error" --title "Connection failure"                  \
      --text="<b>Could not connect to the computer\!</b>\n\n<i>Please check the network connection.</i>" \
      --text-align=center --width=320 --button=gtk-ok --buttons-layout=spread && continue
      
      if [ "$varLog" = "TRUE" ]; then
          yad --text "$RES" --title "Log of Events" --width=600 --wrap --no-buttons
      fi
      
      break
  done
######
###https://github.com/wyllianbs/xfreerdp-gui/blob/master/xfreerdp-gui.sh
#####
