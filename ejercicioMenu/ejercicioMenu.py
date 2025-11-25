from termcolor import colored as clrd
from pyfiglet import Figlet as fglt
import random

def ip_aleatoria():

    clase = input("¿Qué clase quieres? ").strip()
    try:
        if (clase.upper()=="A"):
            oct1=random.randint(0,127)
        elif (clase.upper()=="B"):
            oct1=random.randint(128,191)
        elif (clase.upper() == "C"):
            oct1=random.randint(192,223)
        else:
            raise ValueError

        ip=str(oct1)+"."+str(random.randint(0,255))+"."+str(random.randint(0,255))+"."+str(random.randint(0,255))
        print("Clase de la IP --> ", clase.upper())
        print("IP --> ",ip)
    except ValueError:
        print("No has escrito una clase válida")

def ip_aleatoria2(clase):
    try:
        if (clase.upper()=="A"):
            oct1=random.randint(0,127)
        elif (clase.upper()=="B"):
            oct1=random.randint(127,191)
        elif (clase.upper() == "C"):
            oct1=random.randint(192,223)
        else:
            raise ValueError

        ip=str(oct1)+"."+str(random.randint(0,255))+"."+str(random.randint(0,255))+"."+str(random.randint(0,255))

        print("Clase de la IP --> ", clase.upper())
        print("IP --> ", ip)
    except ValueError:
        print("No has escrito una clase válida")



def menu():
    f = fglt(font='standard')

    print(clrd(f.renderText("PRACTICA"), 'blue'))
    print(clrd("".center(50, "#"), 'green'))
    print(clrd("Ejercicio 1 - Elige una opción", 'red'))
    print("1. Llamada con argumento (ip_aleatoria(random.choice(\"abc\")))")
    print("2. Solicitud por pantalla")
    print("0. Salir del programa")




if __name__ == '__main__':
    while True:
        menu()
        opcion = input("Elección --> ")
        match opcion:
            case "1":
                ip_aleatoria2(random.choice("abc"))
            case "2":
                clase = input("Elige la clase --> ").lower()

                if clase in ["a", "b", "c"]:
                    ip_aleatoria2(clase)
                else:
                    print("error")
            case "0":
                exit()
            case _:
                print("Opcion incorrecta.")



