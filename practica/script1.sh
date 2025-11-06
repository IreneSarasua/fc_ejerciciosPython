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
#Opciones menú Logs
function logNginx() {

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales y las horas:"
  cat $1 | awk -F " " '{print $1, $4}' |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1,$2}'
  echo "Direcciones IP que han intentado acceder a directorios sensibles:"
  cat $1 | grep -E "(/etc/passwd)|(/var/)|(/proc/)" | awk -F " " '{print $1}'
#compleatr
}


# Opciones menú princpal
function opcionSaludo(){
  figlet -f standard.flf  -c Holi

  printf "\n\n\033[0;32mHecho por Irene Sarasua. \n\nNo usar para fines ilícitos.\033[0m"
}

function opcionLog(){
  opcion=1
  until [ $opcion = "3" ]
  do
    printf "\n\033[0;31m Análisis de Logs\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Log de Nginx\n"
    printf "\033[0;32m 2.\033[0m Log de Apache\n"
    printf "\033[0;32m 3.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcion

    case $opcion in
      "1")#Opción Nginx
        read -p "Escribe la ruta del archivo:" ruta1
        if [[ -e "$ruta1" && -f "$ruta1" && -s "$ruta1" && -r "$ruta1" ]]; then
          echo "analizando..."
          # Validar que sea un .log?
          logNginx $ruta1
        else
          echo "Ruta incorrecta"
        fi
        ;;
      "2")#Opción Apache
        echo "Sin desarrollar"
        ;;
      "3")echo "Volviendo al menú principal"
        ;;
      *) echo "Opción incorrecta"
        ;;
    esac
  done
}
function opcionDic(){
  #Comprobar que están instalados
  opcion=1
  until [ $opcion = "4" ]
  do
    printf "\n\033[0;31m Ataque de diccionario\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Crear hash\n"
    printf "\033[0;32m 2.\033[0m Ataque de diccionario con John the Ripper\n"
    printf "\033[0;32m 3.\033[0m Ataque de diccionario con Hashcat\n"
    printf "\033[0;32m 4.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcion

    case $opcion in
      "1")echo "Sin desarrollar"
        ;;
      "2")
        read -p "Introduce el hash --> " mihash
        echo mihash > temp.txt
        hashid mihash
        declare -A dicAlgoritmos=([md5]="md5" [sha1]="raw-sha1" [sha256]="raw-sha256" [sha512]="raw-sha512")
        cond1= true
        while [ true ]; do
            read -p "Introduce el algoritmo (md5, sha1, sha256, sha512 ...) --> " algoritmo
            john --list=formats | grep -i $algoritmo
            john --list=formats | grep -i "md" | cut  -d "," # ver por que no funciona
            if [[ ${!dicAlgoritmos[@]} == *$algoritmo* ]]; then
              cond1= false
            else
              echo "Opcion incorrecta. Vuelve a intentarlo.\n Quizas estes buscando: "
              john --list=formats | grep -i $algoritmo  #pulir
            fi
            echo "dentro "
            echo  $algoritmo
        done

            echo "fuera "
            echo  $algoritmo

        ;;
      "3")echo "Sin desarrollar"
        ;;
      "4")echo "Sin desarrollar"
        ;;
      *) echo "Opción incorrecta"
        ;;
    esac

  done
}

function opcionFinger(){
  opcion=1
  until [ $opcion = "4" ]
  do
    printf "\n\033[0;31m Fingerprinting\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Con fping\n"
    printf "\033[0;32m 2.\033[0m Con nmap\n"
    printf "\033[0;32m 3.\033[0m Lanzar script (con nmap)\n"
    printf "\033[0;32m 4.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcion


  done
    case $opcion in
      "1")echo "Sin desarrollar"
        ;;
      "2")echo "Sin desarrollar"
        ;;
      "3")echo "Sin desarrollar"
        ;;
      "4")echo "Sin desarrollar"
        ;;
      *) echo "Opción incorrecta"
        ;;
    esac
}

function opcionFoot(){
  until [ $opcion = "5" ]
  do
    printf "\n\033[0;31m Footprinting\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Con fping\n"
    printf "\033[0;32m 2.\033[0m Con nmap\n"
    printf "\033[0;32m 3.\033[0m Lanzar script (con nmap)\n"
    printf "\033[0;32m 4.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcion
    printf "\n\n\033[0;321.\m033[0m Metadatos de los ficheros de la ruta actual\n
    \033[0;322.\m033[0m Metdatos de ruta específica\n
    \033[0;323.\m033[0m Metadatos de fichero específico\n
    \033[0;324.\m033[0m (Extra) Editar metadatos\n
    \033[0;325.\m033[0m Volver atrás\n"
    read -p "Elige una opción:" opcion

  done
    case $opcion in
      "1")echo "Sin desarrollar"
        ;;
      "2")echo "Sin desarrollar"
        ;;
      "3")echo "Sin desarrollar"
        ;;
      "4")echo "Sin desarrollar"
        ;;
      "5")echo "Sin desarrollar"
        ;;
      *) echo "Opción incorrecta"
        ;;
    esac

}

function opcionFUZZ(){
  opcion=1
  until [ $opcion = "4" ]
  do
    printf "\n\n\033[0;321.\m033[0m Fuzzing con Wfuzz\n
    \033[0;322.\m033[0m Fuzzing con ffuf\n
    \033[0;323.\m033[0m Nikto\n
    \033[0;324.\m033[0m Volver atrás\n"
    read -p "Elige una opción:" opcion

    case $opcion in
      "1")echo "Sin desarrollar"
        ;;
      "2")echo "Sin desarrollar"
        ;;
      "3")echo "Sin desarrollar"
        ;;
      "4")echo "Sin desarrollar"
        ;;
      *) echo "Opción incorrecta"
        ;;
    esac
  done
}


function main(){
  opcion=1
  until [ $opcion = "7" ]
  do
    menu
    read -p "" opcion

    case $opcion in
      "1")opcionSaludo
        ;;
      "2")opcionLog
        ;;
      "3")opcionDic
        ;;
      "4")opcionFinger
        ;;
      "5")opcionFoot
        ;;
      "6")opcionFUZZ
        ;;
      "7")echo "Sliendo..."
        ;;
      *) echo "Opción incorrecta"
        ;;
      esac
  done
}

main












