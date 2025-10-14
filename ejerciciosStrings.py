#Ejercicios String
from re import match


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


def ej6():
    cadena1 = input("Escribe una palabra: ")
    cadena2 = input("Escribe una palabra: ")
    parte1 = cadena1[0:2]
    sol = cadena2[0:2] + cadena1[2:] + " " + parte1 + cadena2[2:]
    print(sol)
    return sol

def ej7():
    condicion= True
    while condicion:
        nombre = input("Escribe un nombre de usuario: ").strip()
        if len(nombre) < 6:
            print("El nombre de usuario debe contener al menos 6 caracteres")
        elif len(nombre) > 12:
            print("El nombre de usuario no puede contener más de 12 caracteres")
        elif not nombre.isalnum():
            print("El nombre de usuario puede contener solo letras y números")
        else:
            condicion = False
    return True

def ej8():
    email = input("Introduce un email: ").strip()
    dominio = email.split("@")[1]
    print('Nombre: {0}'
          '\nDominio: {1}'
          '\nOrganización: {2}'
          '\nTipo: {3}'.format(email.split("@")[0],
                               dominio, ".".join(dominio.split(".")[0:-1]),
                               dominio.split(".")[-1]))

    return True

def ej9():
    condicion = True
    while condicion:
        try:
            email = input("Introduce un email: ").strip()
            dominio = email.split("@")[-1]
            domPunto = dominio.split(".")
            if len(email.split("@")) != 2:
                print("El email debe contener un arroba.")
            elif len(email.split("@")[0]) < 1:
                print("El nombre debe ser de más de un caracter")
            elif len(domPunto) < 2:
                print("El email debe contener un . despues del arroba.")
            elif len(domPunto[-1]) < 2:
                print("El tipo del dominio debe ser mínimo de 2")
            else:
                print('Nombre: {0}'
              '\nDominio: {1}'
              '\nOrganización: {2}'
              '\nTipo: {3}'.format(email.split("@")[0],
                                   dominio, ".".join(dominio.split(".")[0:-1]),
                                   dominio.split(".")[-1]))
                condicion = False

        except:
            print("Error inesperado")
    return True

def ej10(ip):
    try:
        ip = str(ip)
        ipPuntos = ip.split(".")
        if len(ipPuntos) != 4:
            return False
        else:
            for parte in ipPuntos:
                if not parte.isdigit():
                    return False
                elif len(parte) > 3:
                    return False
                elif int(parte) > 255:
                    return False
    except:
        print("Error inesperado")
        return False
    return True

def ej11(clave):
    sol = 0
    if len(clave) >= 8:
        sol += 1
    if not clave.islower() and not clave.isupper():
        sol += 1
    if not clave.isalpha():
        sol += 1
    if not clave.isalnum():
        sol += 1

    return {
        '1': lambda: "Muy Debil",
        '2': lambda: "Debil",
        '3': lambda: "Normal",
        '4': lambda: "Fuerte"
    }.get(str(sol), lambda: "Muy Debil")()
    # https://ellibrodepython.com/switch-python





#ej1()
#ej2()
#ej3()
#ej4()
#ej5()
#ej6()
#ej7()
#ej8()
#ej9()
#print(ej10("44.44.44.55"))
print(ej11("aaa"))
print(ej11("aaalllllll"))
print(ej11("aaalllllllO"))
print(ej11("aaalllllllO0"))
print(ej11("aaalllllllO0@"))

