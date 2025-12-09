#SCRIPT DE EJEMPLO PARA CIFRAR CON HASHLIB
import hashlib
import os


def ej1():
    passw = input('Introduce contraseña para cifrar: ')
    # Codificacion UTF-8
    passw_utf8 = passw.encode('utf-8')
    print(f'Contraseña con UTF-8 {passw_utf8}')
    # CIFRADO CON SHA256
    h1 = hashlib.new('sha256', passw_utf8)
    h2 = hashlib.sha256(passw_utf8)
    print(f'Cifrado con SHA256: {h1.hexdigest()}')
    print(f'Cifrado con SHA256, llamando al método directamente: {h2.hexdigest()}')
    print(f'Cadena cifrada en binario: {h1.digest()}')
    # CIFRADOS CON DIFERENTES ALGORITMOS – Muestra los que quieras, de la forma rápida print(f'MD5 --> {hashlib.md5(passw_utf8).hexdigest()}')
    print(f'MD5 --> {hashlib.md5(passw_utf8).hexdigest()}')
    print(f'SHA384 --> {hashlib.sha3_384(passw_utf8).hexdigest()}')

    #¿Qué diferencia hay entre cifrar en binario y en heSxadecimal? La longitud
    #Una vez ciframos, ¿podemos descifrar el hash obtenido? No, al menos directamente no...

def cifrar_contrasenia_hex(texto, algoritmo):
    # match algoritmo:
    #     case "md5":
    #         return hashlib.md5(texto).hexdigest()
    #     case "sha256":
    #         return hashlib.sha256(texto).hexdigest()
    #     case "sha3_384":
    #         return hashlib.sha3_384(texto).hexdigest()
    #     case "sha1":
    #         return hashlib.sha1(texto).hexdigest()
    #     case _:
    #         return ""
    try:
        h = hashlib.new(algoritmo, texto.strip("\n").encode('utf-8'))
        return h.hexdigest()
    except:
        print("Error")

def descifrar_hash(hash, algoritmo, diccionario_passwd):
    dic_alg_lon = {
        'md5': 32,
        'sh1': 40,
        'sha3_384': 48,
        'sha256': 64

    }
    try:
        # LEEMOS FICHERO Y LO RECORREMOS LINEA A LINEA: cada una tiene una  contraseña
        # Ojo, hay que quitar el salto de linea con strip
        mi_fichero = open(diccionario_passwd, 'r')
        for passw in mi_fichero.readlines():
            h = cifrar_contrasenia_hex(passw, algoritmo)
            if hash == h:
                print('Contraseña descifrada!')
                print('--> Contraseña: ', passw.strip("\n"))
                print('--> Hash: ', hash)
                print('--> Algoritmo de cifrado: ', algoritmo)
                break
    except:
        print('ERROR')

def descifrar_hash2(hash, diccionario_passwd):
    dic_alg_lon = {
        'md5': 32,
        'sh1': 40,
        'sha3_384': 48,
        'sha256': 64

    }


    try:
        # LEEMOS FICHERO Y LO RECORREMOS LINEA A LINEA: cada una tiene una  contraseña
        # Ojo, hay que quitar el salto de linea con strip
        mi_fichero = open(diccionario_passwd, 'r')
        for passw in mi_fichero.readlines():
            if len(hash) in dic_alg_lon.values():
                for clave, valor in dic_alg_lon.items():
                    if valor == len(hash):
                        h = cifrar_contrasenia_hex(passw, clave)
                        if hash == h:
                            print('Contraseña descifrada!')
                            print('--> Contraseña: ', passw.strip("\n"))
                            print('--> Hash: ', hash)
                            print('--> Algoritmo de cifrado: ', clave)
                            break
    except:
        print('ERROR')

def calcular_hash_fichero(ruta):
    with open(ruta, "rb") as fichero:
        contenido = fichero.read()
    return hashlib.sha256(contenido).hexdigest()
    #¿Por qué tenemos que abrir el archivo en modo binario?
    #¿Qué ocurre si cambiamos una letra del contenido del fichero? Que el hash cambia
    #¿Si cambiáramos el nombre del fichero pero no el contenido, obtendríamos el mismo hash? si
    #¿Se puede recuperar el contenido original a partir del hash? Na
    #¿Por qué SHA-256 es mejor que MD5? Por la longitud del hash generado

def ej6(ruta):
    with open("mis_hash.txt", "a+") as fichero:

        for ruta1 in os.listdir(ruta):
            fichero.write(f'{ruta1}:{calcular_hash_fichero(ruta1)}')
        fichero.close()

def ej6_1():
    print()



if __name__ == '__main__':
    ej1()





