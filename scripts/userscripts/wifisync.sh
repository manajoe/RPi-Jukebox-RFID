#!/bin/bash
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# If WiFi is enabled from the beginning, keep it enabled in the end
rfkill list wifi | grep -i "Soft blocked: no" > /dev/null 2>&1
WIFI_SOFTBLOCK_RESULT=$?
wpa_cli -i wlan0 status | grep 'ip_address' > /dev/null 2>&1
WIFI_IP_RESULT=$?
# if [ "${DEBUG_playout_controls_sh}" == "TRUE" ]; then echo "   WIFI_IP_RESULT='${WIFI_IP_RESULT}' WIFI_SOFTBLOCK_RESULT='${WIFI_SOFTBLOCK_RESULT}'" >> ${PATHDATA}/../logs/debug.log; fi

if [ $WIFI_SOFTBLOCK_RESULT -eq 0 ] && [ $WIFI_IP_RESULT -eq 0 ]
then
	#if [ "${DEBUG_playout_controls_sh}" == "TRUE" ]; then echo "   Wifi will now be deactivated" >> ${PATHDATA}/../logs/debug.log; fi
	echo "Wifi is already activated"
	#rfkill block wifi
	WIFI_STATUS_START=1
	echo $WIFI_STATUS_START
else
	if [ "${DEBUG_playout_controls_sh}" == "TRUE" ]; then echo "   Wifi will now be activated" >> ${PATHDATA}/../logs/debug.log; fi
	echo "Wifi will now be activated"
	WIFI_STATUS_START=0
	rfkill unblock wifi
fi

#for i in {1..50}; do ping -c1 $REMOTE_SERVER &> /dev/null && break; done

while ! ip route | grep -oP 'default via .+ dev wlan0'; do
  echo "interface not up, will try again in 1 second";
  sleep 1;
done

# if Idle Time is set, temporarily set to 0, as sync might take longer than idle time
echo ${PATHDATA}/../../settings/Idle_Time_Before_Shutdown
if [ -s ${PATHDATA}/../../settings/Idle_Time_Before_Shutdown ]
then 
IDLE_TIME=$(head -n 1 ${PATHDATA}/../../settings/Idle_Time_Before_Shutdown)
echo $IDLE_TIME
${PATHDATA}/../playout_controls.sh -c=setidletime -v=0
${PATHDATA}/../playout_controls.sh -c=getidletime
fi
# Start Sync-Script
/home/pi/sync.sh

# Reset Idle Time to previous value if needed
if [[ ! -z $IDLE_TIME ]]
then
${PATHDATA}/../playout_controls.sh -c=setidletime -v=$IDLE_TIME
echo $IDLE_TIME
fi

# Deactivate WiFi if it was disabled in the beginning
if [ $WIFI_STATUS_START -eq 0 ]; then
	echo "Wifi will now be deactivated"
	rfkill block wifi
else
	echo "Wifi stays activated"
fi

