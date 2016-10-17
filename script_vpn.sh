#!/bin/bash

verif=`ls /opt/vpn/x.509/server/ | grep tun1.conf`

if [ -z $verif ];then
	echo "Vous n'avez pas encore de serveur, voulez-vous créer un ? oui/non"
	read reponse
	if [ $reponse == "oui" ];then
		server="server_x.509"
		echo "choisissez une option"
		echo "1- client-to-client"
		echo "2- sans client-to-client"
		read reponse2
		case $reponse2 in
			"1")
			/opt/vpn/x.509/easy-rsa/build-ca
			/opt/vpn/x.509/easy-rsa/build-key-server $server
			/opt/vpn/x.509/easy-rsa/build-dh
			cp /opt/vpn/x.509/easy-rsa/keys/$server.key /opt/vpn/x.509/server/
			cp /opt/vpn/x.509/easy-rsa/keys/$server.cert /opt/vpn/x.509/server/	
			/opt/script/script_ecriture.sh "2"
			echo "le serveur $server à bien été créé"
			;;
			"2")
                        /opt/vpn/x.509/easy-rsa/build-ca
                        /opt/vpn/x.509/easy-rsa/build-key-server $server
                        /opt/vpn/x.509/easy-rsa/build-dh
                        cp /opt/vpn/x.509/easy-rsa/keys/$server.key /opt/vpn/x.509/server/
                        cp /opt/vpn/x.509/easy-rsa/keys/$server.cert /opt/vpn/x.509/server/
                        /opt/script/script_ecriture.sh "1"
			echo "le serveur $server à bien été créé"		
			;;
		esac
else
	echo "Que souhaitez-vous faire ?"
	reponse3=1
	while [ "$reponse3" -gt 7 ]
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
			echo "Le serveur à bien été stopper"
		;;
		"3")
			verif2="client"
			while [ !-z $verif2 ]
			do
                        	echo "Entrez le nom du client"
                        	read client
                        	verif2=`ls /opt/vpn/x.509/clients/ | grep $client`
				if [ -n $client ];then
					echo "Ce nom de client est déjà utilisé, entrez un autre nom"
				fi	
			done	
			/opt/vpn/x.509/easy-rsa/build-key $client
			`cp /opt/vpn/x.509/easy-rsa/keys/$client.* /opt/vpn/x.509/clients/`
		;;
		"4")
			ls -Ad /opt/vpn/x.509/easy-rsa/keys/*.key  | cut -d"/" -f7 | cut -d"." -f1 > random
			sed '/^ca$/d' random > random1 && mv -f random1 random; rm -f random1
			sed '/^server_x.509$/d' random > random1 && mv -f random1 random; rm -f random1
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
			/opt/vpn/x.509/easy-rsa/revoke-full $client_revoque
			rm /opt/vpn/x.509/easy-rsa/keys/$client_revoque.*
			mv /opt/vpn/x.509/clients/$client_revoque.* /opt/vpn/x.509/clients/archives/
			cp /opt/vpn/x.509/easy-rsa/keys/crl.pem /opt/vpn/x.509/server/
		;;
		"5")
			/opt/script/script_ecriture.sh "2"
		;;
		"6")
			/opt/script/script_ecriture.sh "1"
		;;
		"7")
			echo "Êtes-vous sûr de vouloir supprimer la configuration du serveur ? oui/non"
		read reponse4
		if [ $reponse4 == "oui" ];then
			rm /opt/vpn/x.509/server/tun1.conf
			/opt/vpn/x.509/easy-rsa/clean-all
			rm /opt/vpn/x.509/server/*
			rm /opt/vpn/x.509/clients/*
			rm /opt/vpn/x.509/clients/archives/*
			echo "La suppression de la configuration à bien été effectuée"
		fi
		;;
	esac
fi	
