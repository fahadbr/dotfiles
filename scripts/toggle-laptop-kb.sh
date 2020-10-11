
#!/bin/bash

inputDevice='AT Translated Set 2 keyboard'
propId="Device Enabled"
id=$(xinput --list --id-only "$inputDevice")
enabled=$(xinput list-props $id | grep "$propId" | head -n 1 | cut -d ':' -f 2 | grep -Eo '0|1')

if [ $enabled -eq 1 ]; then
	xinput disable $id
else
	xinput enable $id
fi
