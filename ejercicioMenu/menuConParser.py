import optparse
from ejercicioMenu import ip_aleatoria2
import argparse





# parser= optparse.OptionParser()
# parser.add_option("-c", "--clase", dest="opt_arg1", help="Clase para la IP aletoria (A, B o C)")
#
# (opciones, argumentos) = parser.parse_args() #Para guardar opciones y argumentos definidos en las líneas anteriores.
#
# clase = opciones.opt_arg1
# if clase in ["a", "b", "c", "A", "B", "C"]:
#     ip_aleatoria2(clase)
# else:
#     print("error")


# def crear_parser():
#     parser = optparse.OptionParser()
#     parser.add_option("-c", dest="clase", help="Clase de IP {A/a, B/b o C/c}.")
#     (opciones, argumentos) = parser.parse_args()
#     if not opciones.clase:
#         parser.error("Introduce una clase de IP valida")
#     return opciones

def crear_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--clase", dest="clase", help="Clase de IP {A/a, B/b o C/c}.")
    (opciones) = parser.parse_args()
    if opciones.clase not in ["A", "B", "C", "a", "b", "c"]:
        parser.error("Introduce una clase de IP valida")
    return opciones


if __name__ == '__main__':
    opciones=crear_parser()
    ip_aleatoria2(opciones.clase)
