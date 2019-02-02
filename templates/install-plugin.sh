#!/bin/sh

plugin_id=$1
slot_id=$2
cname=$3
ctype=$4
pname=$5

curl --cookie "ilClientId=myilias" --cookie "PHPSESSID=3jjug62mvjau5urpe94sbr5vn4" -o /dev/null "http://localhost/ilias.php?ref_id=31&admin_mode=settings&cmd=view&cmdClass=ilobjcomponentsettingsgui&cmdNode=5s:yj&baseClass=ilAdministrationGUI"
curl --cookie "ilClientId=myilias" --cookie "PHPSESSID=3jjug62mvjau5urpe94sbr5vn4" -o /dev/null "http://localhost/ilias.php?ref_id=31&admin_mode=settings&ctype=${ctype}&cname=${cname}&slot_id=${slot_id}&plugin_id=${plugin_id}&pname=${pname}&cmd=installPlugin&cmdClass=ilobjcomponentsettingsgui&cmdNode=5s:yj&baseClass=ilAdministrationGUI"
curl --cookie "ilClientId=myilias" --cookie "PHPSESSID=3jjug62mvjau5urpe94sbr5vn4" -o /dev/null "http://localhost/ilias.php?ref_id=31&admin_mode=settings&ctype=${ctype}&cname=${cname}&slot_id=${slot_id}&plugin_id=${plugin_id}&pname=${pname}&cmd=activatePlugin&cmdClass=ilobjcomponentsettingsgui&cmdNode=5s:yj&baseClass=ilAdministrationGUI"
