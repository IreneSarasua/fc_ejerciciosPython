#!/bin/bash


# Funciones complementarias

function instalacionPaquetes(){
# Instalación de los paquetes que se usan en el script
sudo apt update # lo necesito?

lista=(toilet figlet john hashid openssl hashcat fping nmap)

for elem in "${lista[@]}"; do
	if ! command -v "$elem" >/dev/null 2>&1; then #devuelve 0 si existe, 1 si no
		#printf "instalando ${elem}..."
		sudo apt install $elem
	fi
done

}



function buscarArchivo(){
	mapfile -t archivo < <(sudo find / -type f -name "$1" 2>/dev/null) # para qe me guarde el resultado en un array
       if  [[ ${#archivo[@]} > 0 ]]; then
        echo "Se encontraron los siguientes archivos:"
       for ruta in "${archivo[@]}"; do
       	echo "$ruta"
       done
       else
       	echo "No se encontraron archichivos con nombre ${1}"
       fi
}




#Opciones menú Logs
function logNginx() {

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales y las horas:"
  awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1,$2}' | sort
  #otra manera
  #awk '{split($4, t, ":"); if (t[2] <= 6)  print $1, substr(t[1], 2), t[2]":"t[3]":"t[4]}' "$1" | sort

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales (solo IPs):"
  awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1}' | sort | uniq

  echo "Direcciones IP que han intentado acceder a directorios sensibles:"
  cat $1 | grep -E "(/etc/passwd)|(/var/)|(/proc/)" | awk -F " " '{print $1}'

  echo "Direcciones IP que han realizado intentos de acceso repetido a recursos inexistentes:"
  awk -F " " '$9 == 404 {print $1}' "$1" | uniq | sort -nr

  echo "IPs con muchos 500/502/503 (posible DoS o fallo backend):"
  awk -F " " '$9 ~ /^50[0, 2, 3]$/  {print $1}' "$1" | uniq | sort -nr

  echo "Direcciones IP que realizan un número elevado de solicitudes en un periodo corto:"
  awk '{split($4, t, ":"); print $1, substr(t[1], 2), t[2]":"t[3]}' "$1" | sort | uniq -c | awk '$1 > 10 {print }' # miro si ha habido mas de 10 peticiones en un minuto de una misma ip

  echo "Rutas con mayor tasa de error (4xx/5xx):"
  # usar printf para poder sacar la tasa con decimales
  # saco los 15 primeros pero podría sacar los que la tasa sea mayor a x
  awk '{
  ip = $1
  tipo = $9
  total[ip]++
  if (tipo  ~ /^[45][0-9]{2}$/ ) err[ip]++

  } END {

  for (ip in total) {
  	tasa = err[ip] / total[ip]
  	printf "%-10.2f %-15s\n", tasa, ip
  }
}' "nginx.log" | sort -r | head -n 15


#compleatr
}
function logApache() {

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales y las horas:"
  awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1,$2}' | sort
  #otra manera
  #awk '{split($4, t, ":"); if (t[2] <= 6)  print $1, substr(t[1], 2), t[2]":"t[3]":"t[4]}' "$1" | sort

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales (solo IPs):"
  awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1}' | sort | uniq

  echo "Direcciones IP que han intentado acceder a directorios sensibles:"
  cat $1 | grep -E "(/etc/passwd)|(/var/)|(/proc/)" | awk -F " " '{print $1}'

  echo "Direcciones IP que han realizado intentos de acceso repetido a recursos inexistentes:"
  awk -F " " '$9 == 404 {print $1}' "$1" | uniq | sort -nr

  echo "IPs con muchos 500/502/503 (posible DoS o fallo backend):"
  awk -F " " '$9 ~ /^50[0, 2, 3]$/  {print $1}' "$1" | uniq | sort -nr

  echo "Direcciones IP que realizan un número elevado de solicitudes en un periodo corto:"
  awk '{split($4, t, ":"); print $1, substr(t[1], 2), t[2]":"t[3]}' "$1" | sort | uniq -c | awk '$1 > 10 {print }' # miro si ha habido mas de 10 peticiones en un minuto de una misma ip

  echo "Rutas con mayor tasa de error (4xx/5xx):"
  # usar printf para poder sacar la tasa con decimales
  # saco los 15 primeros pero podría sacar los que la tasa sea mayor a x
  awk '{
  ip = $1
  tipo = $9
  total[ip]++
  if (tipo  ~ /^[45][0-9]{2}$/ ) err[ip]++

  } END {

  for (ip in total) {
  	tasa = err[ip] / total[ip]
  	printf "%-10.2f %-15s\n", tasa, ip
  }
}' "nginx.log" | sort -r | head -n 15


#compleatr
}


# Opciones menu diccionario
function parteJohn(){

    printf "\033[0;32m 1.\033[0m Diccionario password.lst (por defecto)\n"
    printf "\033[0;32m 2.\033[0m Diccionario rockyou.txt\n"
    printf "\033[0;32m 3.\033[0m Diccionario elotro.txt\n"
    printf "\033[0;32m 4.\033[0m Otro\n \n"
    read -p "Elige una opción: " opcion

    case $opcion in
      "2")
      ruta1=/usr/share/wordlists/rockyou.txt

        ;;
      "3")
      rutaDic=/usr/share/metasploit-framework/data/wordlists/password.lts

      	;;
      "4")
	read -p "Escribe la ruta: " rutaDic
      	;;
      	*) # Opcion por defecto
      	rutadic="/usr/share/john/password.lst"
      ;;
    esac

    if [[ -e "$ruta1" && -f "$ruta1" && -s "$ruta1" && -r "$ruta1" ]]; then
    	john --wordlist="$rutaDic" --format="$1" --pot=resutladoJohn.pot temp_hash.txt
    else
    	john --wordlist="/usr/share/john/password.lst" --format="$1" --pot="resutladoJohn.pot" temp_hash.txt
    fi

}

function parteHashcat(){

    printf "\033[0;32m 1.\033[0m Diccionario password.lst (por defecto)\n"
    printf "\033[0;32m 2.\033[0m Diccionario rockyou.txt\n"
    printf "\033[0;32m 3.\033[0m Diccionario elotro.txt\n"
    printf "\033[0;32m 4.\033[0m Otro\n \n"
    read -p "Elige una opción: " opcion

    case $opcion in
      "2")
      ruta1=/usr/share/wordlists/rockyou.txt

        ;;
      "3")
      rutaDic=/usr/share/metasploit-framework/data/wordlists/password.lts

      	;;
      "4")
	read -p "Escribe la ruta: " rutaDic
      	;;
      	*) # Opcion por defecto
      	rutadic="/usr/share/john/password.lst"
      ;;
    esac

    if [[ -e "$ruta1" && -f "$ruta1" && -s "$ruta1" && -r "$ruta1" ]]; then
    	hashcat -m "$1" --outfile resultadoHashcat.txt -a 0 temp_hash.txt "$rutaDic" --show
    else
    	hashcat -m "$1" --outfile resultadoHashcat.txt -a 0 temp_hash.txt /usr/share/john/password.lst --show
    fi

}





# Opciones menú princpal
function opcionSaludo(){
  figlet -f standard.flf  -c Holi

  printf "\n\n\033[0;32m %s \n\n\033[0;36m%s\033[0m\n" "$(toilet -f future "Hecho por Irene Sarasua" -F border)" "$(toilet -f future "No usar para fines ilícitos.")"
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

    #find -name nginx.log
    mapfile -t logs < <(find / -type f -name "nginx.log" 2>/dev/null) # para qe me guarde el resultado en un array


    case $opcion in
      "1")#Opción Nginx
       printf "\n\033[0;31m Logs de Nginx\033[0m\n"
       buscarArchivo "nginx.log"
       read -p "Escribe la ruta del archivo: " ruta1
        # Valido que exista, que es un archivo, que tiene contenido, que tenga permisos de lectura
        #Validar que sea o .log o .txt? && "$ruta1" =~ \.(log|txt)$
        if [[ -e "$ruta1" && -f "$ruta1" && -s "$ruta1" && -r "$ruta1"  ]]; then
          echo "analizando..."

          logNginx $ruta1
        else
          echo "Error: Comprueba la ruta."
        fi
        ;;
      "2")#Opción Apache
       printf "\n\033[0;31m Logs de Apache\033[0m\n"
       buscarArchivo "apache.log"
       read -p "Escribe la ruta del archivo: " ruta1
        # Valido que exista, que es un archivo, que tiene contenido, que tenga permisos de lectura
        #Validar que sea o .log o .txt? && "$ruta1" =~ \.(log|txt)$
        if [[ -e "$ruta1" && -f "$ruta1" && -s "$ruta1" && -r "$ruta1"   ]]; then
          echo "analizando..."

          logApache $ruta1
        else
          echo "Error: Comprueba la ruta."
        fi


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
    printf "\033[0;32m 4.\033[0m Volver atrás\n \n"
    read -p "Elige una opción: " opcion

    case $opcion in
      "1")#Crear hash
      printf "\n\033[0;31mCrear hash\033[0m\n"
      read -p "Introduce el texto --> " texto
      paraCifrar=(md4 md5 sha1 sha224 sha256 sha384 sha512)
      cond1=true
      while  $cond1 ; do
      	read -p "Introduce el algoritmo (md4, md5, sha1, sha224, sha256, sha384, sha512 --> " algoritmo
      	mapfile -t concide < <(printf '%s\n' "${paraCifrar[@]}" | grep -iE "^${algoritmo}\$" || true)


            if [[ ${#concide[@]} -eq 1 && ${concide[0]} != "" ]]; then
              cond1=false
            else
              echo "Opcion incorrecta. Vuelve a intentarlo.\n Quizas estes buscando: "
              mapfile -t posibilidades < <(printf '%s\n' "${paraCifrar[@]}" | grep -i -- "${algoritmo}" || true)

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "${paraCifrar[@]}"   | xargs
              else
                printf '%s\n' "${posibilidades[@]}" | xargs # xargs para que salgan seguidos
              fi

            fi
        done
      printf '%s' "$texto" | openssl dgst -$algoritmo | awk '{print $NF}'
        ;;
      "2") # Ataque de diccionario con John the Ripper
      printf "\n\033[0;31mAtaque de diccionario con John the Ripper\033[0m\n"
        read -p "Introduce el hash --> " mihash
        echo "$mihash" > temp_hash.txt
        hashid "$mihash"
        mapfile -t formatos_john < <(john --list=formats 2>/dev/null | tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | sort -u)
        cond1=true
        while  $cond1 ; do
            read -p "Introduce el algoritmo (md5, sha1, sha256, sha512 ...) --> " algoritmo


            mapfile -t concide < <(printf '%s\n' "${formatos_john[@]}" | grep -iE "^${algoritmo}\$" || true)
	    #mapfile -t coincide < <(printf '%s\n' "${formatos_john[@]}" | grep -iE "${algoritmo}" || true)

            if [[ ${#concide[@]} -eq 1 && ${concide[0]} != "" ]]; then
              cond1=false
            else
              echo "Opcion incorrecta. Vuelve a intentarlo.\n Quizas estes buscando: "
              mapfile -t posibilidades < <(printf '%s\n' "${formatos_john[@]}" | grep -i -- "${algoritmo}" || true)

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "${formatos_john[@]}"   | xargs
              else
                printf '%s\n' "${posibilidades[@]}" | xargs # xargs para que salgan seguidos
              fi

            fi
        done

        parteJohn $algoritmo

        john --show --pot=".resutladoJohn.pot" --format="$algoritmo"  temp_hash.txt
        grep  -F -- "$miHash" resutladoJohn.pot | awk -F ":" '{print $2}' | uniq

        #grep  -F -- "$miHash" .resutladoJohn.pot
        #recuperar la contraseña

# Eliminar el archivo temoral del hash
	rm temp_hash.txt

        ;;
      "3")#Ataque de diccionario con Hashcat
      printf "\n\033[0;31m Ataque de diccionario con Hashcat\033[0m\n"
      read -p "Introduce el hash --> " mihash
      echo "$mihash" > temp_hash.txt
      hashid "$mihash"
      # para quedarnos solo con la seccion de los hashs
      #las lineas que empiezan por esacios en blanco y números
       # nos quedamos con la primera columna sin los espacios vacios
      mapfile -t formatos_hashcat < <( hashcat --help \
  | awk '/- \[ Hash modes \] -/{flag=1;next}/^- \[/{flag=0}flag' \
  | grep -E '^[[:space:]]*[0-9]+' \
  | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1}')

	cond1=true
        while  $cond1 ; do
            read -p "Introduce el número que corresponda con un algoritmo (md5 = 0, sha1 = 100, sha256 = 1400 ...) --> " algoritmo


            mapfile -t concide < <(printf '%s\n' "${formatos_hashcat[@]}" | grep -iE "^${algoritmo}\$" || true)


            if [[ ${#concide[@]} -eq 1 && ${concide[0]} != "" ]]; then
              cond1=false
            else
              echo "Opcion incorrecta. Vuelve a intentarlo.\n Quizas estes buscando: "
              mapfile -t posibilidades < <( hashcat --help \
  | awk '/- \[ Hash modes \] -/{flag=1;next}/^- \[/{flag=0}flag' \
  | grep -E '^[[:space:]]*[0-9]+' \
  | grep -i "$algoritmo"  )

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "${hashcat --help | awk '/- \[ Hash modes \] -/{flag=1;next}/^- \[/{flag=0}flag' | grep -E '^[[:space:]]*[0-9]+']}"
              else
                printf '%s\n' "${posibilidades[@]}"
              fi

            fi
        done

      parteHashcat $algoritmo
      #hashcat -m 100 --outfile resultadoHashcat.txt -a 0 temp_hash.txt /usr/share/john/password.lst --show
      grep  -F -- "$miHash" resultadoHashcat.txt | awk -F ":" '{print $2}' | uniq
        ;;
      "4")echo "Volviendo al menú principal"
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
    printf "\033[0;32m 1.\033[0m Metadatos de los ficheros de la ruta actual\n"
    printf "\033[0;32m 2.\033[0m Metdatos de ruta específica\n"
    printf "\033[0;32m 3.\033[0m Metadatos de fichero específico)\n"
    printf "\033[0;32m 4.\033[0m (Extra) Editar metadatos\n"
    printf "\033[0;32m 5.\033[0m Volver atrás\n"
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
    printf "\n\033[0;31mFuzzing\033[0m\n"
    printf "=======================================\n"
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
    printf "\033[0;33m%s \033[0m\n" "$(figlet -f standard.flf -c 'Menu')"
    printf "\033[0;32m1. \033[0mSaludar  \n"
    printf "\033[0;32m2. \033[0mAnálisis de logs\n"
    printf "\033[0;32m3. \033[0mAtaques de diccionarios \n"
    printf "\033[0;32m4. \033[0mFingerprinting  \n"
    printf "\033[0;32m5. \033[0mFootprinting  \n"
    printf "\033[0;32m6. \033[0mFuzzing  \n"
    printf "\033[0;31m7. \033[0mSalir\n\n"

    printf "\033[1;33mElige una opción: \033[0m"
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

#instalacionPaquetes
#main

#opcionLog
#opcionDic
opcionFinger










