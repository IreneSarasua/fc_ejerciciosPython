import argparse
import funciones
import funciones2


def crear_parser():
    parser = argparse.ArgumentParser(description="Cifra/descifra ficheros de un directorio")

    modo = parser.add_mutually_exclusive_group(required=True)
    modo.add_argument("--encriptar", dest="enc" , action="store_true", help="Cifrar ficheros")
    modo.add_argument("--desencriptar", dest="desenc" , action="store_true", help="Descifrar ficheros")

    parser.add_argument("--dir", dest="ruta" , default="./pruebas", help="Directorio a procesar (por defecto:./pruebas)")
    parser.add_argument("--clave", dest="clave" , default="clave.key", help="Fichero de clave (por defecto: clave.key)")
    args = parser.parse_args()

    return args

if __name__ == '__main__':

    # CREAR PARSER
    opciones = crear_parser()
    if opciones.enc:
        clave = funciones.obtener_clave(opciones.clave)
        lista_rutas = funciones.ruta_absoluta(opciones.ruta)
        funciones.encriptar(lista_rutas, clave, opciones.ruta)
    if opciones.desenc:
        clave = funciones.obtener_clave(opciones.clave)
        lista_rutas = funciones.ruta_absoluta(opciones.ruta)
        funciones2.desencriptar(lista_rutas, clave)



