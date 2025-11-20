#!/bin/bash


# Funciones complementarias

function instalacionPaquetes(){
# Instalación de los paquetes que se usan en el script
#sudo apt update

lista=(toilet figlet john hashid openssl hashcat fping nmap wfuzz ffuf nikto libimage-exiftool-perl wordlists)

for elem in "${lista[@]}"; do
	# echo $elem
	if ! command -v "$elem" >/dev/null 2>&1; then #devuelve 0 si existe, 1 si no
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

  #echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales y las horas:"
  #awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1,$2}' | sort
  #otra manera
  #awk '{split($4, t, ":"); if (t[2] <= 6)  print $1, substr(t[1], 2), t[2]":"t[3]":"t[4]}' "$1" | sort

  echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales (solo IPs):"
  echo "----------------------------------------------"
  awk -F " " '{print $1, $4}' $1 |  awk -F ":" '$2 <=6 {print}' | awk -F "[" '{print $1}' | sort | uniq

  echo "Direcciones IP que han intentado acceder a directorios sensibles:"
  echo "----------------------------------------------"
  cat $1 | grep -E "(/etc/passwd)|(/var/)|(/proc/)" | awk -F " " '{print $1}' | sort | uniq


  echo "Direcciones IP que han realizado intentos de acceso repetido a recursos inexistentes:"
  echo "----------------------------------------------"
  # sort -r reverso, -n numerico
  awk -F " " '$9 == 404 {print $1}' "$1" | sort -nr | uniq


  echo "IPs con muchos 500/502/503 (posible DoS o fallo backend):"
  echo "----------------------------------------------"
  awk -F " " '$9 ~ /^50[0, 2, 3]$/  {print $1}' "$1" | sort -nr | uniq

  echo "Direcciones IP que realizan un número elevado de solicitudes en un periodo corto:"
  echo "----------------------------------------------"
  awk '{split($4, t, ":"); print $1, substr(t[1], 2), t[2]":"t[3]}' "$1" | sort | uniq -c | awk '$1 > 4 {print }' # miro si ha habido mas de 5 peticiones en un minuto de una misma ip

  echo "Rutas con mayor tasa de error (4xx/5xx):"
  echo "----------------------------------------------"
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


}
function logApache() {

 echo "Direcciones IP que han intentado realizar solicitudes a horas poco habituales (solo IPs):"
  echo "----------------------------------------------"
  awk 'int(substr($3, 0, 2)) <=6 {print}' $1 | grep -i "from" | awk -F "from" '{print $2}' | awk -F " " '{print $1}' | sort | uniq

  echo "Direcciones IP que realizan un número elevado de solicitudes en un periodo corto:"
  echo "----------------------------------------------"
 grep -i "from" "$1" | awk -F "from" '{print $2, $1}' | awk '{split($7, t, ":"); print $1, $5, $6, t[1]":"t[2]}' | sort | uniq -c | awk '$1 > 4 {print }'
 # miro si ha habido mas de 5 peticiones en un minuto de una misma ip


}


# Opciones menu diccionario
function parteJohn(){

    printf "\033[0;32m 1.\033[0m Diccionario password.lst (por defecto)\n"
    printf "\033[0;32m 2.\033[0m Diccionario rockyou.txt\n"
    printf "\033[0;32m 3.\033[0m Otro diccionario de wordlists\n"
    printf "\033[0;32m 4.\033[0m Otro\n \n"
    read -p "Elige una opción: " opcionJohn

    case $opcionJohn in
      "2")
      # sudo gunzip -k rockyou.txt.gz para descomrimirlo...

      rutaDic=/usr/share/wordlists/rockyou.txt

        ;;
      "3")

      rutaDic=/usr/share/wordlists/wifite.txt

      	;;
      "4")
	read -p "Escribe la ruta: " rutaDic
      	;;

      	*) # Opcion por defecto
      	rutaDic="/usr/share/john/password.lst"
      ;;
    esac

    if [[ -e "$rutaDic" && -f "$rutaDic" && -s "$rutaDic" && -r "$rutaDic" ]]; then
    	john --wordlist="$rutaDic" --format="$1" --pot="resultadoJohn.pot" temp_hash.txt
    	echo "" > resultadoJohn.pot
    else
    	echo "No se pudo ejecutar hashcat. Error al leer el diccionario."
    fi

}

#hashcat (v6.2.6)
function parteHashcat(){

    printf "\033[0;32m 1.\033[0m Diccionario password.lst (por defecto)\n"
    printf "\033[0;32m 2.\033[0m Diccionario rockyou.txt\n"
    printf "\033[0;32m 3.\033[0m Diccionario elotro.txt\n"
    printf "\033[0;32m 4.\033[0m Otro\n \n"
    read -p "Elige una opción: " opcionCat

    case $opcionCat in
      "2")
      rutaDic=/usr/share/wordlists/rockyou.txt

        ;;
      "3")
      rutaDic=/usr/share/wordlists/wifite.txt

      	;;
      "4")
	read -p "Escribe la ruta: " rutaDic
      	;;
      	*) # Opcion por defecto
      	rutaDic="/usr/share/john/password.lst"
      ;;
    esac

    if [[ -e "$rutaDic" && -f "$rutaDic" && -s "$rutaDic" && -r "$rutaDic" ]]; then
    	hashcat -m "$1" --outfile resultadoHashcat.txt -a 0 temp_hash.txt "$rutaDic" --show
    	#echo "" > resultadoHashcat.txt
    else
    	echo "No se pudo ejecutar hashcat. Error al leer el diccionario."
    fi

}





# Opciones menú princpal
function opcionSaludo(){
  figlet -f standard.flf  -c Holi

  printf "\n\n\033[0;32m %s \n\n\033[0;36m%s\033[0m\n" "$(toilet -f future "Hecho por Irene Sarasua" -F border)" "$(toilet -f future "No usar para fines ilícitos.")"
}




function opcionLog(){
  opcionlog=1
  until [ $opcionlog = "3" ]
  do
    printf "\n\033[0;31mAnálisis de Logs\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Log de Nginx\n"
    printf "\033[0;32m 2.\033[0m Log de Apache\n"
    printf "\033[0;32m 3.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcion

    #find -name nginx.log
    mapfile -t logs < <(find / -type f -name "nginx.log" 2>/dev/null) # para qe me guarde el resultado en un array


    case $opcionlog in
      "1")#Opción Nginx
       printf "\n\033[0;31mLogs de Nginx\033[0m\n"
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
       printf "\n\033[0;31mLogs de Apache\033[0m\n"
       buscarArchivo "apache.log"
       buscarArchivo "auth.log"
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
      	opcionlog=-1
        ;;
    esac
  done
}

function opcionDic(){
  #Comprobar que están instalados
  opciondic=1
  until [ $opciondic = "4" ]
  do
    printf "\n\033[0;31mAtaque de diccionario\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Crear hash\n"
    printf "\033[0;32m 2.\033[0m Ataque de diccionario con John the Ripper\n"
    printf "\033[0;32m 3.\033[0m Ataque de diccionario con Hashcat\n"
    printf "\033[0;32m 4.\033[0m Volver atrás\n \n"
    read -p "Elige una opción: " opcion

    case $opciondic in
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
              printf "Opcion incorrecta. Vuelve a intentarlo.\nQuizas estes buscando: \n"
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
              printf "Opcion incorrecta. Vuelve a intentarlo.\nQuizas estes buscando: \n"
              mapfile -t posibilidades < <(printf '%s\n' "${formatos_john[@]}" | grep -i -- "${algoritmo}" || true)

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "${formatos_john[@]}"   | xargs
              else
                printf '%s\n' "${posibilidades[@]}" | xargs # xargs para que salgan seguidos
              fi

            fi
        done

        parteJohn $algoritmo


        #john --show --pot=".resultadoJohn.pot" --format="$algoritmo"  temp_hash.txt
        #grep  -F -- "$mihash" resultadoJohn.pot | awk -F ":" '{print $2}' | uniq

        #grep  -F -- "$mihash" .resultadoJohn.pot
        #recuperar la contraseña

	# Eliminar el archivo temoral del hash
	rm temp_hash.txt

        ;;
      "3")#Ataque de diccionario con Hashcat
      #el kali de clase es v7.1.2 -hh ara que saque los modos
      printf "\n\033[0;31mAtaque de diccionario con Hashcat\033[0m\n"
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
              printf "Opcion incorrecta. Vuelve a intentarlo.\nQuizas estes buscando: \n"
              mapfile -t posibilidades < <( hashcat --help \
  | awk '/- \[ Hash modes \] -/{flag=1;next}/^- \[/{flag=0}flag' \
  | grep -E '^[[:space:]]*[0-9]+' \
  | grep -i "$algoritmo"  )

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "$(hashcat --help | awk '/- \[ Hash modes \] -/{flag=1;next}/^- \[/{flag=0}flag' | grep -E '^[[:space:]]*[0-9]+')"
              else
                printf '%s\n' "${posibilidades[@]}"
              fi

            fi
        done

      parteHashcat $algoritmo

      #hashcat -m 100 --outfile resultadoHashcat.txt -a 0 temp_hash.txt /usr/share/john/password.lst --show


      echo "Si se encontró algo, aparecera a continuación."
      grep  -E "$mihash" resultadoHashcat.txt | awk -F ":" '{print $2}' | uniq


        ;;
      "4")echo "Volviendo al menú principal"
        ;;
      *) echo "Opción incorrecta"
      	opciondic=-1
        ;;
    esac

  done
}

      # ^(?:(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$
      # /\b((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)+(?:\/{1}((?:[0-9])|(?:[1-2][0-9])|(?:3[0-2]))\b)?)|((?:[a-f0-9:]+:+)+(?:[a-f0-9])+(?:\/{1}((?:(?:3[0-2]|[12]?\d)))\b)?)/gm   https://regex101.com/library/lKzPHl?orderBy=MOST_UPVOTES&page=5&search=ip

function opcionFinger(){
  regexIp='^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(/(3[0-2]|[12]?[0-9]))?$'
  opcionfinger=1
  until [ $opcionfinger = "4" ]
  do
    printf "\n\033[0;31mFingerprinting\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Con fping\n"
    printf "\033[0;32m 2.\033[0m Con nmap\n"
    printf "\033[0;32m 3.\033[0m Lanzar script (con nmap)\n"
    printf "\033[0;32m 4.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcionfinger


    case $opcionfinger in
      "1")
      #Con fping
      printf "\n\033[0;31mFingerprinting con fping\033[0m\n"
      read -p "Introduce la IP --> " miIp

      if [[ $miIp =~ $regexIp ]]; then
      	atrFping="-a "

      	read -p "¿Qieres mostrar los objetivos que estan disponibles? (S/n) --> " eleccion

      	if [[ $eleccion =~ ^(n|N)$ ]]; then
      		atrFping=""
      	fi

      	read -p "¿Qieres forzar IPv4? (s/N) --> " eleccion

      	if [[ $eleccion =~ ^(s|S)$ ]]; then
      		atrFping+="-4 "
      	else
      		#-4 y -6 son excluyentes.
      		read -p "¿Qieres forzar IPv6? (s/N) --> " eleccion

      		if [[ $eleccion =~ ^(s|S)$ ]]; then
      			atrFping+="-6 "
      		fi

      	fi



      	#echo $atrFping
      	fping $atrFping  -g "$miIp" 2>/dev/null #| grep -i "alive"



      else
      	echo "No era una IP válida."
      fi


        ;;
      "2")
      #Con nmap
      printf "\n\033[0;31mFingerprinting con nmap\033[0m\n"
      read -p "Introduce la IP --> " miIp

      if [[ $miIp =~ $regexIp ]]; then


      	sudo nmap "$miIp" | grep -i "open" > "${miIp}.txt" #guardo solo lo importante

      	echo "Puertos aiertos de la IP: $miIp"
      	#grep -i "open"  "${miIp}.txt"
      	cat "${miIp}.txt"

      else
      	echo "No era una IP válida."
      fi

        ;;
      "3")
      #Con scrit y nmap
      printf "\n\033[0;31mFingerprinting con script y nmap\033[0m\n"
      #/usr/share/nmap/scripts/

      read -p "Introduce la IP --> " miIp

      if [[ $miIp =~ $regexIp ]]; then

      	read -p "Introduce la ruta del script (suelen estar en /usr/share/nmap/scripts/) --> " miScript

      	if [[ -e "$miScript" && -f "$miScript" ]]; then
      		sudo nmap --script "$miScript" "$miIp"

      	else
      		echo "No era una ruta válida."
      	fi


      else
      	echo "No era una IP válida."
      fi



        ;;
      "4")
      echo "Volviendo al menú principal"
        ;;
      *)
      echo "Opción incorrecta"
      	opcionfinger=-1
        ;;
    esac


    done

}

function opcionFoot(){
  opcionfoot=1
  until [ $opcionfoot = "5" ]
  do
    printf "\n\033[0;31mFootprinting\033[0m\n"
    printf "=======================================\n"
    printf "\033[0;32m 1.\033[0m Metadatos de los ficheros de la ruta actual\n"
    printf "\033[0;32m 2.\033[0m Metdatos de ruta específica\n"
    printf "\033[0;32m 3.\033[0m Metadatos de fichero específico\n"
    printf "\033[0;32m 4.\033[0m (Extra) Editar metadatos\n"
    printf "\033[0;32m 5.\033[0m Volver atrás\n"
    read -p "Elige una opción: " opcionfoot


# mirar tambien subdirectorios con -r?
#no mostrar los unreadbles con grep?
    case $opcionfoot in
      "1")
      printf "\n\033[0;31mMetadatos de los ficheros de la ruta actual\033[0m\n"
      exiftool .
        ;;
      "2")
      printf "\n\033[0;31mMetdatos de ruta específica\033[0m\n"
      read -p "Escribe la ruta del directorio: " ruta1
        # Valido que exista, que es un directorio, que tenga permisos de lectura
        if [[ -e "$ruta1" && -d "$ruta1" && -r "$ruta1"  ]]; then
        	exiftool "$ruta1"
        else
        	echo "Error: Comprueba la ruta. Recuerda que debes tener permisos de lectura."
        fi
        ;;
      "3")
      printf "\n\033[0;31mMetadatos de fichero específico\033[0m\n"
      read -p "Escribe la ruta del archivo: " ruta1
        # Valido que exista, que es un archivo, que tenga permisos de lectura
        if [[ -e "$ruta1" && -f "$ruta1" &&  -r "$ruta1" ]]; then
        	exiftool "$ruta1"
        else
        	echo "Error: Comprueba la ruta del archivo. Recuerda que debes tener permisos de lectura."
        fi
        ;;
      "4")

      # Editar los metadatos existentes o añador tambien metadatos? NEcesito permiso de escritura?
      #pero no se cual es esl tag que necsito
      printf "\n\033[0;31m(Extra) Editar metadatos\033[0m\n"
      read -p "Escribe la ruta del archivo: " ruta1
        # Valido que exista, que es un archivo, que tenga permisos de lectura. Permiso de ecritura me daba problemas && -w "$rura1"
      if [[ -e "$ruta1" && -f "$ruta1" &&  -r "$ruta1" ]]; then

      #parte elegir un atributo
      #exiftool -listw
      # mapfile -t atrTodos < <(exiftool "$ruta1" | awk -F ":" '{gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1}')

      	mapfile -t atrTodos < <(exiftool -listw 2>/dev/null \
  | tail -n +2 \
  | tr ' ' '\n' \
  | sed '/^$/d' \
  | sort -u)

      	# que al menos haya un atributo, diría que ya no tengo ese problema, pero no esta dde más
      	if [[ ${#atrTodos[@]} -ge 1 && ${atrTodos[0]} != "" ]]; then



	cond1=true
        while  $cond1 ; do
        read -p "Introduce el metadato a modificar (case senitive) --> " atrMod
      	mapfile -t concide < <(printf '%s\n' "${atrTodos[@]}" | grep -E "^${atrMod}\$" || true)

            if [[ ${#concide[@]} -eq 1 && ${concide[0]} != "" ]]; then
              cond1=false
            else
              printf "Opcion incorrecta. Vuelve a intentarlo.\nQuizas estes buscando: \n"
              mapfile -t posibilidades < <(printf '%s\n' "${atrTodos[@]}" | grep -i -- "${atrMod}" || true)

              if [[ ${#posibilidades[@]} -eq 0 ]]; then
              	printf '%s\n' "${atrTodos[@]}"   | head -n 30 # que sino salen muchos
              else
                printf '%s\n' "${posibilidades[@]}" | head -n 30
              fi

            fi
        done
        fi

        read -p "Introduce el nuevo valor para el metadato $atrMod --> " atrModVal

        read -p "¿Seuro qué quieres cambiar el valor del metadato $atrMod con \"$atrModVal\"? (s/N)--> " confirmar

        # Solo intento modificar si ponen s o S, en cualquir otro caso se cancela.
        if [[ $confirmar =~ ^(s|S)$ ]]; then
        	exiftool "-${atrMod}=${atrModVal}" -overwrite_original "$ruta1"

        else
        	echo "Se canceló la modificación"

        fi


      else
      	echo "Error: Comprueba la ruta del archivo. Recuerda que debes tener permisos de lectura."
      fi


        ;;
      "5")
      echo "Volviendo al menú principal"
        ;;
      *) echo "Opción incorrecta"
      	opcionfoot=-1
        ;;
    esac
      done

}

function opcionFUZZ(){
  opcionffuz=1
  until [ $opcionffuz = "4" ]
  do
    printf "\n\033[0;31mFuzzing\033[0m\n"
	printf "=======================================\n"
	printf "\033[0;32m 1.\033[0m Fuzzing con Wfuzz\n"
	printf "\033[0;32m 2.\033[0m Fuzzing con ffuf\n"
	printf "\033[0;32m 3.\033[0m Nikto\n"
	printf "\033[0;32m 4.\033[0m Volver atrás\n"
	read -p "Elige una opción: " opcionffuz


    #hay que pedir el "dicconario"?
    wordlistFuzz="/usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt"
    case $opcionffuz in
      "1")
      printf "\n\033[0;31mFuzzing con Wfuzz\033[0m\nLos resultados se guardaran en resultadoWfuzz.txt\n"
      read -p "Escribe la URL del objetivo (http://x.x.x.x): " ruta1
      read -p "Escribe la ruta del diccionario que quieras utilizar, sino, se usara el de por defecto: " dicfuzz

      if [[ -n $ruta1 ]]; then

      	if [[ -e "$dicfuzz" && -f "$dicfuzz"  ]]; then
      		wfuzz -c  --sc 200,301,302,401,403,500,404   -u "${ruta1%/}/FUZZ"   -w "$dicfuzz"  -t 200 -oF "resultadoWfuzz.txt"
      	else
      		wfuzz -c  --sc 200,301,302,401,403,500,404   -u "${ruta1%/}/FUZZ"   -w "$wordlistFuzz" -t 200  -oF "resultadoWfuzz.txt"
      	fi

      else
      	printf "Error: no habias escrito nada para la ruta"
      fi


        ;;
      "2")
      printf "\n\033[0;31mFuzzing con ffuf\033[0m\nLos resultados se guardaran en resultadoffuf.txt\n"
      read -p "Escribe la URL del objetivo: " ruta1
      read -p "Escribe la ruta del diccionario que quieras utilizar, sino, se usara el de por defecto: " dicfuzz


      if [[ -n $ruta1 ]]; then

      	if [[ -e "$dicfuzz" && -f "$dicfuzz"  ]]; then
      		ffuf -c -u "${ruta1%/}/FUZZ" -w "$dicfuzz"   -o "resultadoffuf.txt"
      	else
      		ffuf -c -u "${ruta1%/}/FUZZ" -w "$wordlistFuzz"   -o "resultadoffuf.txt"
      	fi

      else
      	printf "Error: no habias escrito nada para la ruta"
      fi

        ;;
      "3")
      printf "\n\033[0;31mNikto\033[0m\nLos resultados se guardaran en resultadoNikto.txt\n"
      read -p "Escribe el host/URL del objetivo: " ruta1

      if [[ -n $ruta1 ]]; then
      	nikto -h "$ruta1" -o resultadoNikto.txt
      else
      	printf "Error: no habias escrito nada para la ruta"
      fi


        ;;
      "4")
      echo "Volviendo al menú principal"
        ;;
      *) echo "Opción incorrecta"
      opcionffuz=-1
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
      	opcion=-1
        ;;
      esac
  done
}

instalacionPaquetes
main

#opcionLog
#opcionDic
#opcionFinger
#opcionFoot
#opcionFUZZ










