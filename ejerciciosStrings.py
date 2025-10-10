#Ejercicios String




def ej1():
    cadena = input("Escribe una cadena: ")
    caracter = input("Escribe un caracter: ")
    sol= ""
    for i in range(0, len(cadena)):
        if i < len(cadena)-1:
            sol += cadena[i] + caracter
        else:
            sol += cadena[i]
    print(sol)

def ej2():
    cadena = input("Escribe un texto: ")
    caracter = input("Escribe un caracter: ")
    sol= cadena.replace(" ", caracter)

    print(sol)


def ej3():
    cadena = input("Escribe un texto: ")
    caracter = input("Escribe un caracter: ")
    sol= ""

    for i in range(0, len(cadena)):
        if cadena[i].isdigit():
            sol += caracter
        else:
            sol += cadena[i]
    print(sol)


def ej4():
    cadena = input("Escribe el nombre del archivo: ")
    if cadena.endswith(".exe") or cadena.endswith(".bat") or cadena.endswith(".scr"):
        print("Archivo peligroso")
    else:
        print("Archivo no peligroso")

def ej5():
    cadena = input("Escribe un texto: ")
    if cadena.__contains__("free") or cadena.__contains__("offer")or cadena.__contains__("click"):
        print("Texto peligroso")
    else:
        print("Texto no peligroso")





#ej1()
#ej2()
#ej3()
#ej4()
ej5()

