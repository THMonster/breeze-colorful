#!/bin/bash

function foo()
{
    if [[ $1 -gt 0 ]]
    then
        echo '2'
    else
        echo '10'
    fi
}

basepath=$(cd `dirname $0`; pwd)
template_path="/home/midorikawa/src/kde-theme-backup/template/"
opacity='0.7'
primary_color=`python3 "${basepath}/get_primary_color.py" "${1}"`

color_factor_r=`expr 70 - $((16#${primary_color:0:2}))`
color_factor_g=`expr 70 - $((16#${primary_color:2:2}))`
color_factor_b=`expr 70 - $((16#${primary_color:4:2}))`
color_factor_r=`expr ${color_factor_r} '*' $(foo ${color_factor_r})`
color_factor_g=`expr ${color_factor_g} '*' $(foo ${color_factor_g})`
color_factor_b=`expr ${color_factor_b} '*' $(foo ${color_factor_b})`
color_factor=`expr ${color_factor_r} + ${color_factor_g} + ${color_factor_b}`
echo ${color_factor}
# if [[ $((16#${primary_color:0:2})) -le 70 && $((16#${primary_color:2:2})) -le 70 && $((16#${primary_color:4:2})) -le 70 ]]
if [[ ${color_factor} -ge 0 ]]
then
    if [[ $(cat /tmp/breeze-colorful.temp 2>/dev/null | grep 'dark') != '' ]]
    then
        exit
    fi
    echo 'dark' > /tmp/breeze-colorful.temp
    cat ${basepath}/template/colors | sed "s/<IsoaSFlus-font-color>/171,178,191/g" > ${basepath}/breeze-colorful/colors
    primary_color='282c34'
    echo "white ${primary_color}"
else
    if [[ $(cat /tmp/breeze-colorful.temp 2>/dev/null | grep 'light') != '' ]]
    then
        exit
    fi
    echo 'light' > /tmp/breeze-colorful.temp
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
