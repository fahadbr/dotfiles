#!/bin/bash

powermanLib=$HOME/.dotfiles/scripts/powerman
dimmer=$powermanLib/dimmer.sh
locker=$powermanLib/lock.sh

dimTriggered=false
dpmsTriggered=false
lockTriggered=false
sleepTriggered=false

audioIdleTime=0
defaultInterval=1
dimmedInterval=.25
interval=$defaultInterval
audioModeTriggered=false

# check whether on ac or power
varsPrefix=$1
if [[ "$varsPrefix" != "ac" ]] && [[ "$varsPrefix" != "bat" ]]; then
	echo "invalid first arg \"$varsPrefix\". must be either \"ac\" or \"bat\""
	exit 1
fi

varsFile=$powermanLib/$varsPrefix-vars

# source the timeouts
source $powermanLib/$varsPrefix-vars || exit 1
echo "using vars file $varsFile"

echo "timeouts: "
echo "dimTimeout: "$dimTimeout"ms"
echo "dpmsTimeout: "$dpmsTimeout"ms"
echo "lockTimeout: "$lockTimeout"ms"
echo "sleepTimeout: "$sleepTimeout"ms"

# test for dependencies
which xprintidle &>/dev/null || ( echo "xprintidle not installed" && exit 1 )
which pacmd &>/dev/null || ( echo "pacmd (pulseaudio) not installed" && exit 1 )
xprintidle &>/dev/null || ( echo "no X session running" && exit 1 )


function reset {
	dimTriggered=false
	lockTriggered=false
	sleepTriggered=false
	dpmsTriggered=false
	audioIdleTime=0
	interval=$defaultInterval
	$dimmer restore
}

function run {
	while true; do
		sleep $interval

		local actualIdleTime=$(xprintidle)
		local runningAudioSinks=$(pacmd list-sink-inputs | grep -c 'state: RUNNING')

		if [[ $runningAudioSinks -ne 0 ]]; then
			# echo 'audio is running'
			audioIdleTime=$actualIdleTime

			if [[ "$audioModeTriggered" == "false" ]]; then
				echo 'audio mode triggered'
				audioModeTriggered=true
			fi

			#echo "actual: $actualIdleTime, audio: $audioIdleTime, effective: $idletime"
			continue
		fi

		if [[ "$audioModeTriggered" == "true" ]]; then
			echo 'audio mode reset'
			audioModeTriggered=false
		fi

		local idletime=$(($actualIdleTime - $audioIdleTime))

		#echo "actual: $actualIdleTime, audio: $audioIdleTime, effective: $idletime"

		if [[ $dimTimeout -gt 0 ]]; then
			if [[ "$dimTriggered" == "false" ]] && [[ $idletime -gt $dimTimeout ]]; then
				echo "dimming now"
				$dimmer dim
				interval=$dimmedInterval
				dimTriggered=true
			elif [[ "$dimTriggered" == "true" ]] && [[ $idletime -lt $dimTimeout ]]; then
				echo "undimming now"
				reset
			fi
		fi

		if [[ $dpmsTimeout -gt 0 ]]; then
			if [[ "$dpmsTriggered" == "false" ]] && [[ $idletime -gt $dpmsTimeout ]]; then
				echo "putting screen on standby"
				xset dpms force standby
				dpmsTriggered=true
			fi
		fi

		if [[ $lockTimeout -gt 0 ]]; then
			if [[ "$lockTriggered" == "false" ]] && [[ $idletime -gt $lockTimeout ]]; then
				$locker
				echo "locking now"
				lockTriggered=true
			fi
		fi

		if [[ $sleepTimeout -gt 0 ]]; then
			if [[ "$sleepTriggered" == "false" ]] && [[ $idletime -gt $sleepTimeout ]]; then
				systemctl suspend
				echo "sleeping now"
				sleepTriggered=true
			fi
		fi

	done
}

pkill -RTMIN+3 i3blocks
xset dpms 0 0 0
xset s 0 0
reset
run
