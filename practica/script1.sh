#!/bin/bash

# Variables para el color de la letra
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
# Variables para el font de la letra
bold=$(tput bold)
normal=$(tput sgr0)





function menu() {
echo -e "${YELLOW}"
figlet -f standard.flf  -c Menu
echo -e "${NC}"
echo -e "
${GREEN}1.${NC} Saludar
${GREEN}2.${NC} Amálisis de logs
${GREEN}3.${NC} Ataques de diccionarios
${GREEN}4.${NC} Fingerprinting
${GREEN}5.${NC} Footprinting
${GREEN}6.${NC} Fuzzing
${RED}7.${NC} Salir
"
printf "\033[0;33mElige una opción: \033[0m"
}

function opcion1(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}

function opcion2(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}
function opcion3(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}
function opcion4(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}

function opcion5(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}

function opcion6(){
  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilegales.\033[0m"
}


function main(){
  opcion=1
  until [ $opcion = "7" ]
  do
    menu
    read -p "" opcion

    case $opcion in
      "1")opcion1
        ;;
      "2")opcion2
        ;;
      "3")opcion3
        ;;
      "4")opcion4
        ;;
      "5")opcion5
        ;;
      "6")opcion6
        ;;
      *) echo "Opción incorrecta"
        ;;
      esac
  done
echo "Sliendo..."
}

main












