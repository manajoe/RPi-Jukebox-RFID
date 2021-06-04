#!/bin/bash
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ACTIVE_OUTPUT=`mpc outputs | awk '/enabled/ { print $2 }' `
echo $ACTIVE_OUTPUT
#############################################################

# for i in "$@"
# do
    # case $i in
        # -c=*|--command=*)
        # COMMAND="${i#*=}"
        # ;;
    # esac
# done

# case $COMMAND in
    # shutdown)
		# ACTIVE_OUTPUT=2
        # ;;
# esac


if [ $ACTIVE_OUTPUT -eq 2 ]
then
		echo "Activate USB"
		# Save Volume and Max Volume settings for previous output
        $PATHDATA/../playout_controls.sh -c=getmaxvolume > $PATHDATA/../../settings/Max_Volume_Limit_Headphone
		$PATHDATA/../playout_controls.sh -c=getvolume > $PATHDATA/../../settings/Audio_Volume_Level_Headphone
		# Change Audio Output in config files
		sudo sed -i "s/defaults.pcm.card 0/defaults.pcm.card 1/" /usr/share/alsa/alsa.conf		
		sudo sed -i "s/defaults.ctl.card 0/defaults.ctl.card 1/" /usr/share/alsa/alsa.conf		
		sudo sed -i "s/Headphone/PCM/" $PATHDATA/../../settings/Audio_iFace_Name
		# Change Audio Output in MPD
		mpc enable 1 && mpc disable 2
		# Get previous Volume and Max Volume from file
		$PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<"$PATHDATA/../../settings/Max_Volume_Limit_Speaker")
		$PATHDATA/../playout_controls.sh -c=setvolume -v=$(<"$PATHDATA/../../settings/Audio_Volume_Level_Speaker")
elif [ $ACTIVE_OUTPUT -eq 1 ]
then
	if [[ $1 == "default" ]]
	then
		echo "Nothing to do"
	
	else
	
        echo "Activate Headphone"
		# Save Volume and Max Volume settings for previous output
		#/home/pi/RPi-Jukebox-RFID/scripts/playout_controls.sh -c=getmaxvolume > /home/pi/RPi-Jukebox-RFID/settings/Max_Volume_Limit_Speaker
		$PATHDATA/../playout_controls.sh -c=getmaxvolume > $PATHDATA/../../settings/Max_Volume_Limit_Speaker
		$PATHDATA/../playout_controls.sh -c=getvolume > $PATHDATA/../../settings/Audio_Volume_Level_Speaker	
		# Change Audio Output in config files		
		sudo sed -i "s/defaults.pcm.card 1/defaults.pcm.card 0/" /usr/share/alsa/alsa.conf
		sudo sed -i "s/defaults.ctl.card 1/defaults.ctl.card 0/" /usr/share/alsa/alsa.conf
		sudo sed -i "s/PCM/Headphone/" $PATHDATA/../../settings/Audio_iFace_Name
		# Change Audio Output in MPD
		mpc enable 2 && mpc disable 1
		# Get previous Volume and Max Volume from file		
		$PATHDATA/../playout_controls.sh -c=setmaxvolume -v=$(<"$PATHDATA/../../settings/Max_Volume_Limit_Headphone")
		$PATHDATA/../playout_controls.sh -c=setvolume -v=$(<"$PATHDATA/../../settings/Audio_Volume_Level_Headphone")
	fi

	
fi


#cp /home/pi/RPi-Jukebox-RFID/settings/Audio_iFace_Name_Speaker /home/pi/RPi-Jukebox-RFID/settings/Audio_iFace_Name
#sudo service mpd restart

