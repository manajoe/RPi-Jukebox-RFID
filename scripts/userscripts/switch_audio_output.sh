#!/bin/bash
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Get active MPC Output
ACTIVE_OUTPUT=`mpc outputs | awk '/enabled/ { print $2 }' `
echo $ACTIVE_OUTPUT "is active"
#############################################################

# Define variables for Output Names and IDs
MPC_OUTPUT1="PCM"
ALSA_OUTPUT1="1"
MPC_OUTPUT2="Headphone"
ALSA_OUTPUT2="0"


if [ $ACTIVE_OUTPUT -eq 2 ]
then
		echo "Activate PCM"
		# Save Volume and Max Volume settings for previous output
        $PATHDATA/../playout_controls.sh -c=getmaxvolume > $PATHDATA/../../settings/Max_Volume_Limit_$MPC_OUTPUT2
		$PATHDATA/../playout_controls.sh -c=getvolume > $PATHDATA/../../settings/Audio_Volume_Level_$MPC_OUTPUT2
		# Change Audio Output in config files
		sudo sed -i "s/defaults.pcm.card $ALSA_OUTPUT2/defaults.pcm.card $ALSA_OUTPUT1/" /usr/share/alsa/alsa.conf		
		sudo sed -i "s/defaults.ctl.card $ALSA_OUTPUT2/defaults.ctl.card $ALSA_OUTPUT1/" /usr/share/alsa/alsa.conf		
		sudo sed -i "s/$MPC_OUTPUT2/$MPC_OUTPUT1/" $PATHDATA/../../settings/Audio_iFace_Name
		# Change Audio Output in MPD
		mpc enable 1 && mpc disable 2
		# Get previous Volume and Max Volume for new output from file
		#MAXVOLLIMIT1=$PATHDATA/../../settings/Max_Volume_Limit_$MPC_OUTPUT1
		#AUDIOVOLLEVEL1=$PATHDATA/../../settings/Audio_Volume_Level_$MPC_OUTPUT1
		#$PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<"$MAXVOLLIMIT1")
		if [ ! -f  ${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT1} ]
		then
			echo ${PATHDATA}/../../settings/Max_Volume_Limit > ${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT1}
		fi
		if [ ! -f  ${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT1} ]
		then
			echo ${PATHDATA}/../../settings/Startup_Volume > ${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT1}
		fi
		
		$PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT1})
		$PATHDATA/../playout_controls.sh -c=setvolume -v=$(<${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT1})
elif [ $ACTIVE_OUTPUT -eq 1 ]
then
	if [[ $1 == "default" ]]
	then
		echo "Nothing to do"
	
	else
	
        echo "Activate Headphone"
		# Save Volume and Max Volume settings for previous output
		#/home/pi/RPi-Jukebox-RFID/scripts/playout_controls.sh -c=getmaxvolume > /home/pi/RPi-Jukebox-RFID/settings/Max_Volume_Limit_Speaker
		$PATHDATA/../playout_controls.sh -c=getmaxvolume > $PATHDATA/../../settings/Max_Volume_Limit_$MPC_OUTPUT1
		$PATHDATA/../playout_controls.sh -c=getvolume > $PATHDATA/../../settings/Audio_Volume_Level_$MPC_OUTPUT1	
		# Change Audio Output in config files		
		sudo sed -i "s/defaults.pcm.card $ALSA_OUTPUT1/defaults.pcm.card $ALSA_OUTPUT2/" /usr/share/alsa/alsa.conf
		sudo sed -i "s/defaults.ctl.card $ALSA_OUTPUT1/defaults.ctl.card $ALSA_OUTPUT2/" /usr/share/alsa/alsa.conf
		sudo sed -i "s/$MPC_OUTPUT1/$MPC_OUTPUT2/" $PATHDATA/../../settings/Audio_iFace_Name
		# Change Audio Output in MPD
		mpc enable 2 && mpc disable 1
		# Get previous Volume and Max Volume for new output from file	
		# MAXVOLLIMIT2=$PATHDATA/../../settings/Max_Volume_Limit_$MPC_OUTPUT2
		# AUDIOVOLLEVEL2=$PATHDATA/../../settings/Audio_Volume_Level_$MPC_OUTPUT2
		# $PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<"$MAXVOLLIMIT2")
		# $PATHDATA/../playout_controls.sh -c=setvolume -v=$(<"$AUDIOVOLLEVEL2")
		if [ ! -f  ${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT2} ]
		then
			echo ${PATHDATA}/../../settings/Max_Volume_Limit > ${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT2}
		fi
		if [ ! -f  ${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT2} ]
		then
			echo ${PATHDATA}/../../settings/Startup_Volume > ${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT2}
		fi		
		
		
		
		$PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<${PATHDATA}/../../settings/Max_Volume_Limit_${MPC_OUTPUT2})
		$PATHDATA/../playout_controls.sh -c=setvolume -v=$(<${PATHDATA}/../../settings/Audio_Volume_Level_${MPC_OUTPUT2})		
	fi

	
fi

#cp /home/pi/RPi-Jukebox-RFID/settings/Audio_iFace_Name_Speaker /home/pi/RPi-Jukebox-RFID/settings/Audio_iFace_Name
#sudo service mpd restart

#sudo service oled_phoniebox restart
