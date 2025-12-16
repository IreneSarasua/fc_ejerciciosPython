from funciones import ruta_absoluta, obtener_clave
from cryptography.fernet import Fernet
import os

def desencriptar(rutas, clave1):
    f = Fernet(clave1)
    for elemento in rutas:
        fich = open(elemento, 'rb')
        ruta_segmentada = fich.name.split("/")
        if ruta_segmentada[-1].startswith("encript_"):
            contenido_original = f.decrypt(fich.read())
            fich.close()

            fich = open(elemento, 'wb')
            fich.write(contenido_original)
            fich.close()
            nuevo_nombre = ruta_segmentada[-1].split("encript_")[-1]
            ruta_segmentada[-1] = nuevo_nombre
            os.rename(fich.name, '/'.join(ruta_segmentada))
        else:
            fich.close()



if __name__ == '__main__':
    clave = obtener_clave()
    lista_rutas = ruta_absoluta('./pruebas')
    desencriptar(lista_rutas, clave)