#!/bin/bash

brightnessFile=/sys/class/backlight/intel_backlight/brightness
lastBrightnessFile=$HOME/.local/lastbrightness

targetDimDurationMs=300
targetUndimDurationMs=300
targetFPS=60
targetDimBrightness=100
msPerFrame=$(echo "scale=3;1/$targetFPS" | bc)

function getBrightness {
	cat $brightnessFile
}

function adjustBrightness {
	targetBrightness=$1
	targetDurationMs=$2
	currentBrightness=$(getBrightness)

	whileCond="-gt"
	incLimitCond="-lt"
	if [[ $targetBrightness -gt $currentBrightness ]]; then
		whileCond="-lt"
		incLimitCond="-gt"
	fi

	# get increment value based on FPS, duration and current brightness
	inc=$(echo "scale=3;($currentBrightness-$targetBrightness)/($targetFPS*$targetDurationMs/1000)" | bc | cut -d '.' -f 1)

	while $(test $currentBrightness $whileCond $targetBrightness); do
		new_b=$(echo "scale=0;$currentBrightness - $inc" | bc)
		if $(test $new_b $incLimitCond $targetBrightness); then
			new_b=$targetBrightness
		fi
		echo $new_b > $brightnessFile
		currentBrightness=$new_b
		sleep $msPerFrame
	done
}


function dim {
	if [[ -f $lastBrightnessFile ]]; then
		echo 'screen is already dimmed'
		exit 0
	fi

	getBrightness > $lastBrightnessFile

	adjustBrightness $targetDimBrightness $targetDimDurationMs
}

function restore {
	if [[ ! -f $lastBrightnessFile ]]; then
		echo 'brightness file does not exist. perhaps it was restored already?'
		exit 0
	fi

	adjustBrightness $(cat $lastBrightnessFile) $targetUndimDurationMs
	rm $lastBrightnessFile
}

if [[ $1 ]]; then
	cmd=$1
	shift 1
	$cmd $@
fi

