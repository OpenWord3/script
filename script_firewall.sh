#!/bin/bash

# Affichage du menu

reponse="oui"
while [ $reponse == "oui" ]
do

echo "Bienvenue sur le script de gestion du firewall"
echo " "
echo "Que voulez-vous faire ?"
echo " "
echo "1 - Ajout d'une règle"
echo "2 - Suppression d'une règle"
echo "3 - Gestion du NAT"
echo "4 - Sortir du module"
echo " "

until [[ ${choix} =~ ^[0-9]+$ ]]; do
    echo "Veuillez entrer votre choix"
    read choix
done

if [[ $choix == "1" ]]
    then
    	/opt/script/script_add_rules.sh

elif [[ $choix == "2" ]]
	then
		/opt/script/script_del_rules.sh

elif [[ $choix == "3" ]]
	then
		/opt/script/script_nat.sh
                
elif [[ $choix == "4" ]]
	then
		exit

else
        echo "Lisez bien l'instruction svp";
fi

echo "Voulez-vous reprendre l'opération ? oui/non"
read reponse
done
