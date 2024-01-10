#!/bin/sh

[[ -f /home/madjestic/.Xresources ]] && xrdb -merge /home/madjestic/.Xresources

#feh --bg-scale 1920x1080 /home/madjestic/Documents/pics/neutrino3.jpg &
feh --no-fehbg --bg-scale 2256x1504 '/home/madjestic/Documents/Images/neutrino3.jpg' &
xcompmgr -cCfF -r7 -o.65 -l-10 -t-8 -D7 &
xsetroot -cursor_name left_ptr
urxvtd --quiet --opendisplay --fork
export ALTERNATE_EDITOR=""
export EDITOR=emacsclient

exec dbus-launch --sh-syntax --exit-with-session xmonad
# exec dbus-launch --sh-syntax --exit-with-session openbox
# echo '1' > '/sys/module/snd_hda_intel/parameters/power_save'
