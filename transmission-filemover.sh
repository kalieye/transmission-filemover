#!/usr/bin/env bash
# move torrent to appropriate directory
# AUTHOR: Lino <lino@kalieye.net> http://github.com/kalieye http://kalieye.net

# configure your transmission username/password here, leave empty if you disabled auth

TR_USERNAME=""
TR_PASSWORD=""

# DO NOT TOUCH

function log {
    echo "`date '+%d-%m-%Y %H:%M:%S'`   $1" >> "$LOGFILE"
}

LOGFILE="/var/lib/transmission-daemon/.config/transmission-daemon/transmission-filemover.log"
TRACKER=`transmission-remote -n "$TD_USERNAME:$TD_PASSWORD" -t $TR_TORRENT_ID -it | grep "Tracker 0" | awk '{print $3}'`
CONFIG_FILE="/var/lib/transmission-daemon/.config/transmission-daemon/transmission-filemover.conf"

DESTINATION=""

declare -A trackers=( )
while read -r -a trfilters; do
    set -- "${trfilters[@]}"
    for trfilter; do
        if [[ $trfilter = *"="* ]]; then
            trackers[${trfilter%%=*}]=${trfilter#*=}
        fi
    done
done < $CONFIG_FILE

for i in "${!trackers[@]}"; do
    if [[ $TRACKER =~ .*$i.* ]]; then
        DESTINATION=${trackers[$i]}
        transmission-remote -n "$TR_USERNAME:$TR_PASSWORD" -t $TR_TORRENT_ID --move $DESTINATION
    fi
done

if [ -n "$DESTINATION" ]; then
    log "torrent $TR_TORRENT_NAME finished [ID: $TR_TORRENT_ID | TRACKER: $TRACKER] moving to $DESTINATION"
else
    log "torrent $TR_TORRENT_NAME finished [ID: $TR_TORRENT_ID | TRACKER: $TRACKER] no rule match for moving"
fi
