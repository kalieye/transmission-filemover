This script helps you manage your torrents file when using transmission-daemon

**how to use**

place transmission-filemover.conf and transmission-filemover.sh in the /var/lib/transmission-daemon/.config/transmission-daemon directory

edit transmission-filemover.conf and place each filter in a single line with this format:

filter:/destination/directory

where filter is part of the tracker URL (for example if your tracker is mydomain.com you can use mydomain as filter)