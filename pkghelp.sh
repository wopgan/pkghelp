#!/usr/bin/env bash

#variaveis

version=1.0.0
author="wopgan"

showdistro=$(sed -s 's/ //g;s/"//g;s/NAME=//g' /etc/os-release | sed q)

red="\033[31;1m"
blue="\033[34;1m"
white="\033[37;0m"
#green="\033[32;1m"


#funcoes

error() {
	echo -e "\n${red} Opção inválida, favor escolher opção entre 1 e 5\n"
}

whatsdistro() {
	echo -e "\n${blue}VOCÊ ESTÁ USANDO $showdistro\n"
}

confirmdistro() {
	while :
	do 
		case $showdistro in
			ArchLinux)
				whatsdistro
				menu
				break
				;;
			Ubuntu)
				whatsdistro
				menu
				break
				;;
			ManjaroLinux)
				whatsdistro
				menu
				break
				;;
		esac
	done
}

searchpkg() {
	local use=""
	while :
	do
		case $showdistro in 
			ArchLinux)
				echo -e "Digite o nome do pacote que você está buscando: "
				read -r pkg
				use="pacman -Ss $pkg"
				$use | grep extra | sed -s 's/extra//g;s/community//g;s/core//g'
				menu
				break
				;;
			Ubuntu)
				echo -e "Digite o nome do pacote que você está buscando: "
				read -r pkg
				sudo apt search "$pkg"
				menu
				break
				;;
			ManjaroLinux)
				echo -e "Você quer um pacote do AUR ou do repositório NORMAL, use [a|n]"
				read -r repo
					if [ "$repo" == "n" ]; then
						echo -e "Digite o nome do pacote que deseja procurar: "
						read -r pkg
						pamac search "$pkg"
						menu 
					elif [ "$repo" == "a" ]; then
						echo -e "Digite o nome do pacote que deseja procurar: "
						read -r pkg
						pamac search -a "$pkg"
						menu
					else 
						echo -e 'Vócê deve usar "a" para AUR ou "n" para Normal!\n'
					fi
				menu
				break
				;;
			esac
		done
}

installpkg() {
	local use=""
	while :
	do 
		case $showdistro in
			ArchLinux)
				echo -e "Digite qual pacote vocẽ quer instalar: "
				read -r pkg
				sudo pacman -S "$pkg"
				menu
				break
				;;
			Ubuntu)
				echo -e "Digite qual pacote vocẽ quer instalar: "
				read -r pkg
				sudo apt install -y "$pkg"
				menu
				break
				;;
			ManjaroLinux)
				echo -e "Você quer um pacote do AUR ou do repositório NORMAL, use [a|n]"
					if [ "$repo" == "n" ]; then
						read -r pkg
						pamac install "$pkg" --no-confirm
						menu
					elif [ "$repo" == "a" ]; then	
						read -r pkg
						pamac build "$pkg" --no-confirm
						menu
					else
						echo -e 'Vócê deve usar "a" para AUR ou "n" para Normal!\n'
					fi	
				menu
				break
				;;	
		esac
	done
}


updatesystem(){
	while :
	do
		case "$showdistro" in
			ArchLinux)
			sudo pacman -Syu --noconfirm 
			menu
			break
			;;
			Ubuntu)
			sudo apt dist-upgrade -y
			menu
			break
			;;
			ManjaroLinux)
			sudo pamac update
			menu
			break
			;;
		esac
	done

}

menu() {

	echo -e "${white}1 - Pesquisar pacote;"
	echo -e "${white}2 - Instalar pacote;"
	echo -e "${white}3 - Confirmar Distribuição;"
	echo -e "${white}4 - Sobre o Script"
	echo -e "${white}5 - Atualizar Sistema"
	echo -e "${white}6 - Sair"
	echo -e "${white}Escolha uma opção: "
	read -r choice
	while :
	do
		case $choice in
			1) 
			searchpkg
			break
			;;
			2)
			installpkg
			break
			;;
			3)
			confirmdistro
			break
			;;
			4)
			echo -e "\nPKGHELP esta na versão $version, script em shell escrito por $author\n"
			menu
			;;
			5)
			updatesystem
			menu
			;;			
			6)
			exit 0
			;;
			*)
			error
			sleep 3
			clear
			menu
			break
			;;
		esac
	done

}

#principal


main() {

	echo -e "\nPKGHELP é um script para que você possa procurar e instalar o pacote que precisa \nno seu sistema sem dificuldades! Para continuar escolha uma das opções abaixo: \n "
	menu
}

main
