#!/usr/bin/env python3

import sys
import json
import os
import subprocess
import time
import math
from datetime import datetime, timezone
from dateutil.parser import parse

def get_short_time(dt, now):
    parsed_dt = dt.strftime('%I:%M').lstrip('0') + dt.strftime('%p').lower()
    if now:
        timeRemainingMinutes = math.floor((dt - now).total_seconds()/60)
        return parsed_dt, timeRemainingMinutes
    return parsed_dt


def main(args):
    jsonInput = args[1]
    events = json.loads(jsonInput)
    output_dir = os.path.expanduser('~/.local/share/i3blocks/calendar')
    event_file_prefix = 'event-'
    count_filename = 'count'

    event_filepath = os.path.join(output_dir, event_file_prefix)
    count_filepath = os.path.join(output_dir, count_filename)

    if not events:
        os.exit(0)

    for filename in os.listdir(output_dir):
        if event_file_prefix in filename or count_filename == filename:
            os.unlink(os.path.join(output_dir, filename))

    # send notifications
    index = 0
    count = len(events)
    now = datetime.now(timezone.utc)
    for event in events:
        start_dt = parse(event['start'])
        end_dt = parse(event['end'])

        startTimeStr, timeRemainingMinutes = get_short_time(start_dt, now)
        endTimeStr = get_short_time(end_dt, None)

        msg = '{}\nLocation: {}\n{} - {}\n{} minutes remaining'.format(
                event['title'],
                event['location'],
                startTimeStr,
                endTimeStr,
                timeRemainingMinutes)
        subprocess.run(['notify-send', '-a', 'Axoni Calendar', 'Event Reminder', msg])

        startEpoch = int(start_dt.timestamp())
        endEpoch = int(end_dt.timestamp())

        nextEventString='startTime="{}"\nendTime="{}"\ntitle="{}"\nlocation="{}"\nurl="{}"'.format(
                startEpoch,
                endEpoch,
                event['title'],
                event['location'],
                event['url'])

        # write event file for i3blocks
        outfile = event_filepath + str(index)
        with open(outfile, 'w+') as f:
            f.write(nextEventString)
        index += 1


    # write index file for i3blocks
    with open(count_filepath, 'w+') as f:
        f.write("count={}\ncountTimestamp={}".format(count, int(now.timestamp())))

    # send signal for i3blocks to update
    subprocess.run(['pkill', '-RTMIN+4', 'i3blocks'])


if __name__ == '__main__':
    main(sys.argv)
