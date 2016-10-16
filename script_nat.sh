#!/bin/bash

echo "Que voulez-vous faire ?"
echo " "
echo "1- Activer le nat"
echo "2- Désactiver le nat"
echo "3- Retour au menu principal"
echo " "
read choix
nat="iptables -t nat -A POSTROUTING -j MASQUERADE"
case $choix in
	"1")
		verif=`grep -w -n "\#$nat" /opt/scripts/firewall.sh | cut -d":" -f1`
		if [ -z $verif ];then
			echo "Le nat est déjà activé"
		else
			sed -i -e "s/^#$nat/$nat/g" /opt/scripts/firewall.sh
		fi
	;;
	"2")
		verif=`grep -w -n "$nat" /opt/scripts/firewall.sh | cut -d":" -f1`
                if [ -z $verif ];then
                        echo "Le nat est déjà désactivé"
                else
                        sed -i -e "s/^$nat/#$nat/g" /opt/scripts/firewall.sh
                fi	
	;;
	"3")
		sudo /opt/scripts/script_firewall.sh
	;;	
esac


#Execution du script de configuration
sudo /opt/scripts/firewall.sh

sudo iptables-save > /opt/scripts/firewall.conf
