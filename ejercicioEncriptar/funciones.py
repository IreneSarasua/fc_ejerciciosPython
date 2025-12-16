from cryptography.fernet import Fernet
import os


def generar_clave():
    clave = Fernet.generate_key()
    fichero_clave=open('clave.key','wb')
    fichero_clave.write(clave)
    fichero_clave.close()

def obtener_clave():
    fichero=open('clave.key','rb')
    #DEVUELVE LA CLAVE
    return fichero.readline()


def ruta_absoluta(directorio):
    lista_directorios=[]
    for ruta,subdirectorios,archivos in os.walk(directorio):
        for a in archivos:
            lista_directorios.append(os.path.abspath(os.path.join(ruta, a)))
    return lista_directorios

def encriptar(rutas,clave):
    f=Fernet(clave)
    for elemento in rutas:
        #OBTENEMOS EL CONTENIDO DEL FICHERO Y LO ENCRIPTAMOS
        # → Abrimos el fichero en modo lectura-binario
        # → Leemos el contenido (read) y lo encriptamos con el metodo encrypt de la clase Fernet
        # → Guardamos el contenido encriptado en una variable que usaremos después para sobreescribir el contenido
        # → Cerramos el fichero para poder abrirlo después en modo escritura
        # → Añadimos un control para comprobar si tiene el prefijo “cifrado” para comprobar si ya está cifrado
        fich = open(elemento,'rb')
        contenido_encriptado = f.encrypt(fich.read())
        fich.close()
        #SOBREESCRIBIMOS EL CONTENIDO DE LOS FICHEROS POR EL CONTENIDO ENCRIPTADO
        # → Abrimos fichero en modo escritura-binario
        # → Escribimos el contenido encriptado que hemos obtenido previamente
        # → Cerramos el fichero
        fich = open(elemento,'wb')
        fich.write(contenido_encriptado)
        fich.close()




if __name__ == '__main__':
    print(obtener_clave())
    lista_rutas = ruta_absoluta('./pruebas')
    print(lista_rutas)