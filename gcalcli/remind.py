#!/usr/bin/env python3

import sys
import json
import os
import subprocess
import time
import math
from datetime import datetime, timezone
from dateutil.parser import parse

def get_short_time(timeval, now):
    dt = parse(timeval)
    parsed_dt = dt.strftime('%I:%M').lstrip('0') + dt.strftime('%p').lower()
    if now:
        timeRemainingMinutes = math.floor((dt - now).total_seconds()/60)
        return parsed_dt, timeRemainingMinutes
    return parsed_dt


def main(args):
    jsonInput = args[1]
    events = json.loads(jsonInput)
    outfile = os.path.expanduser('~/.local/share/i3blocks/calendar-reminder')

    if not events:
        with open(outfile, "w+") as f:
            f.write('')
        os.exit(0)

    # send notifications
    for event in events:
        now = datetime.now(timezone.utc)
        startTimeStr, timeRemainingMinutes = get_short_time(event['start'], now)
        endTimeStr = get_short_time(event['end'], None)

        msg = '{}\nLocation: {}\n{} - {}\n{} minutes remaining'.format(
                event['title'],
                event['location'],
                startTimeStr,
                endTimeStr,
                timeRemainingMinutes)
        subprocess.run(['notify-send', '-a', 'Axoni Calendar', 'Event Reminder', msg])

    # get first event start time
    t = parse(events[0]['start'])
    epoch = int(t.timestamp())

    nextEventString='startTime="{}"\ntitle="{}"\nlocation="{}"\nurl="{}"'.format(
            epoch,
            event['title'],
            event['location'],
            event['url'])

    # write file to update i3bar
    with open(outfile, 'w+') as f:
        f.write(nextEventString)


if __name__ == '__main__':
    main(sys.argv)
