#!/bin/bash

verif=`ls /opt/vpn/x.509/server/ | grep tun1.conf`
if [ -z $verif ];then
	echo "Vous n'avez pas encore de serveur, voulez-vous créer un ? oui/non"
	read reponse
	if [ $reponse == "oui" ];then
		server="server_x509"
		echo "choisissez une option"
		echo "1- client-to-client"
		echo "2- sans client-to-client"
		read reponse2
		case $reponse2 in
			"1")
			cd /opt/vpn/x.509/easy-rsa/
			source vars
			./clean-all
			./build-ca
			./build-key-server $server
			./build-dh
			cp /opt/vpn/x.509/easy-rsa/keys/$server.key /opt/vpn/x.509/server/
			cp /opt/vpn/x.509/easy-rsa/keys/$server.crt /opt/vpn/x.509/server/	
			/opt/script/script_ecriture.sh "2"
			echo "le serveur $server à bien été créé"
			;;
			"2")
			cd /opt/vpn/x.509/easy-rsa/
                        source vars
                        ./clean-all
                        ./build-ca
                        ./build-key-server $server
                        ./build-dh
                        cp /opt/vpn/x.509/easy-rsa/keys/$server.key /opt/vpn/x.509/server/
                        cp /opt/vpn/x.509/easy-rsa/keys/$server.crt /opt/vpn/x.509/server/
                        /opt/script/script_ecriture.sh "1"
			echo "le serveur $server à bien été créé"		
			;;
		esac
	fi	
else
	echo "Que souhaitez-vous faire ?"
	reponse3=0
	while [ "$reponse3" -gt 7 ] || [ "$reponse3" -lt 1 ]
	do
		echo "1- Lancer la configuration du serveur"
		echo "2- Stopper la configuration du serveur"
		echo "3- Créer un client"
		echo "4- Révoquer un client"
		echo "5- Actionner l'option client-to-client"
		echo "6- Désactiver l'option client-to-client"
		echo "7- Supprimer de façon définitive la configuration du serveur (ATTENTION)"
		read reponse3
	done
	case $reponse3 in
		"1")
			openvpn --config /opt/vpn/x.509/server/tun1.conf --verb 6
			echo "Le serveur est bien lancé"
		;;
		"2")
			pkill openvpn
			echo "Le serveur a bien été stopper"
		;;
		"3")
			existe="oui"
			while [ "$existe" == "oui" ]
			do
                        	echo "Entrez le nom du client"
                        	read client
                        	verif2=`ls /opt/vpn/x.509/clients/ | grep "^$client.key"`
				if [ "$verif2" != "" ];then
					echo "Ce nom de client est déjà utilisé, entrez un autre nom"
				else
					existe="non"
				fi	
			done
                        cd /opt/vpn/x.509/easy-rsa/
                        ./build-key $client
			cp /opt/vpn/x.509/easy-rsa/keys/$client.* /opt/vpn/x.509/clients/
		;;
		"4")
			echo "Choisissez le client que vous souhaitez révoquer"
			ls -Ad /opt/vpn/x.509/easy-rsa/keys/*.key  | cut -d"/" -f7 | cut -d"." -f1 > random
			sed '/^ca$/d' random > random1 && mv -f random1 random; rm -f random1
			sed '/^server_x509/d' random > random1 && mv -f random1 random; rm -f random1
			IFS=$'\n'
			tableau=( $( cat random ) )

			i=0
			while [ "$i" -lt "${#tableau[*]}" ]
			do
				echo $((i+1))- ${tableau[$i]}
				let i++
			done
			read h
			let h--
			client_revoque=${tableau[$h]}
			rm random
                        cd /opt/vpn/x.509/easy-rsa/
			./revoke-full $client_revoque
			rm /opt/vpn/x.509/easy-rsa/keys/$client_revoque.*
			mv /opt/vpn/x.509/clients/$client_revoque.* /opt/vpn/x.509/clients/archives/
			cp /opt/vpn/x.509/easy-rsa/keys/crl.pem /opt/vpn/x.509/server/
		;;
		"5")
			/opt/script/script_ecriture.sh "2"
			echo "L'option client-to-client a bien été activée"
		;;
		"6")
			/opt/script/script_ecriture.sh "1"
			echo "L'option client-to-client a bien été désactivée"
		;;
		"7")
			echo "Êtes-vous sûr de vouloir supprimer la configuration du serveur ? oui/non"
		read reponse4
		if [ $reponse4 == "oui" ];then
			rm /opt/vpn/x.509/server/tun1.conf
                        cd /opt/vpn/x.509/easy-rsa/
			./clean-all
			rm /opt/vpn/x.509/server/*
			rm /opt/vpn/x.509/clients/*.
			rm /opt/vpn/x.509/clients/archives/*
			echo "La suppression de la configuration a bien été effectuée"
		fi
		;;
	esac
fi	
