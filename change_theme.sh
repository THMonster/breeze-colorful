#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
template_path="/home/midorikawa/src/kde-theme-backup/template/"
opacity='0.7'
primary_color=`python3 "${basepath}/get_primary_color.py" "${1}"`

if [[ $((16#${primary_color:0:2})) -le 70 && $((16#${primary_color:2:2})) -le 70 && $((16#${primary_color:4:2})) -le 70 ]]
then
    cat ${basepath}/template/colors | sed "s/<IsoaSFlus-font-color>/171,178,191/g" > ${basepath}/breeze-colorful/colors
    primary_color='282c34'
    echo "white ${primary_color}"
else
    rm  ${basepath}/breeze-colorful/colors 2> /dev/null
    opacity=0
    echo "black ${primary_color}"
fi

cat ${basepath}/template/widgets/tooltip | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/widgets/tooltip.svgz
# cat ${basepath}/template/widgets/panel-background | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/widgets/panel-background.svgz
cat ${basepath}/template/widgets/panel-background | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/0/g" | gzip > ${basepath}/breeze-colorful/widgets/panel-background.svgz
cat ${basepath}/template/dialogs/background | sed "s/<IsoaSFlus-color>/${primary_color}/g" | sed "s/<IsoaSFlus-opacity>/${opacity}/g" | gzip > ${basepath}/breeze-colorful/dialogs/background.svgz

rm -rf ${HOME}/.local/share/plasma/desktoptheme/breeze-colorful/
cp -rf ${basepath}/breeze-colorful ${HOME}/.local/share/plasma/desktoptheme/

kwriteconfig5 --file plasmarc --group Theme --key name --type string default
sleep 1
kwriteconfig5 --file plasmarc --group Theme --key name --type string breeze-colorful
