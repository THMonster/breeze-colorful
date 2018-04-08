#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
template_path="/home/midorikawa/src/kde-theme-backup/template/"
opacity='0.5'
primary_color=`python3 "${basepath}/get_primary_color.py" "${1}"`

cat ${basepath}/template/widgets/tooltip | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/widgets/tooltip.svgz
cat ${basepath}/template/widgets/panel-background | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/widgets/panel-background.svgz
cat ${basepath}/template/dialogs/background | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/dialogs/background.svgz

if [[ $((16#${primary_color:0:2})) -le 55 && $((16#${primary_color:2:2})) -le 55 && $((16#${primary_color:4:2})) -le 55 ]]
then
    cat ${basepath}/template/colors | sed "s/<IsoaSFlus-font-color>/200/g" > ${basepath}/breeze-colorful/colors
fi


rm -rf ${HOME}/.local/share/plasma/desktoptheme/breeze-colorful/
cp -rf ${basepath}/breeze-colorful ${HOME}/.local/share/plasma/desktoptheme/

kwriteconfig5 --file plasmarc --group Theme --key name --type string default
sleep 1
kwriteconfig5 --file plasmarc --group Theme --key name --type string breeze-colorful
