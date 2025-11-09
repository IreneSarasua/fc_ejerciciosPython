import  datetime
from _socket import gethostname, gethostbyname
import netifaces
from  random import randint as rt
import ipaddress

def ej1():
    try:
        a = int(input("Escribe un número: "))
        print(a)
        a += 3
        print("El número es", a)
    except IOError:
        print("Error de entada/salida")
    except ValueError:
        print("Error de conversión de dato.")
    except:
        print("Error")

def ej2(num):
    if not(isinstance(num, int)):
        '''raise TypeError'''
        return "error de tipo de dato"

    return 0 <= num <= 10

def ej3():
    try:
        nombre = input("Escribe un nombre: ")
        edad = int(input("Escribe la edad: "))

        print("Hola", nombre, "naciste en el año", datetime.datetime.now().year - edad)
    except:
        print("Error")

def espar(num):
    return num%2 == 0

def mult3(num):
    return num%3 == 0

def losPares(num):
    for i in range(1, num):
        if espar(i):
            print(i)

def ej4():
    num = int(input("Escribe un número: "))

    print("Es par:", espar(num))
    print("Es multiplo de 3:", mult3(num))
    losPares(num)

def ej7():
    try:
        a = int(input("Introduce la temperatura --> "))
        b = input("¿Celsius(c) o Fahrenheit? --> ").lower()
        if b== 'c':
            f = 1.8 * a + 32
            print("Temperatura: ",a, "ºC | ", f, "ºF")
        elif b == "f":
            c = (a -32)/1.8
            print("Temperatura: ", c, "ºC | ", a, "ºF")

    except:
        print("Error")

def divisores(num):
    sol = ""

    for i in range(1, num+1):
        if num%i ==0:
            sol += str(i) + " "

    print("DIVISORES")
    print(sol)

def multiplos(num, cant):
    sol = ""

    for i in range(1, cant + 1):
        sol += str(i * num) + " "

    print("MULTIPLOS")
    print(sol)

def ej8():
    try:
        a = int(input("Introduce un número --> "))
        divisores(a)
        multiplos(a, 5)

    except:
        print("Error")

def pideNum():
    while True:
        try:
            a = int(input("Introduce un número --> "))
            return a
        except:
            print("Por favor que sea un número")

def ej9():
    a = pideNum()
    print(a)

def pideOp():
    while True:
        try:
            r = int(input("Introduce la operación (1. sumar, 2.restar, 3.multiplicar, 4.dividir)--> "))
            if 0<r <5:
                return r
            else:
                print("Por favor que sea un número del 1 al 4")

        except:
            print("Por favor que sea un número")

def calc(num1, num2, op):
    sol = ""
    op1=""
    match op:
        case 1:
            op1 = "sumar"
            return num1 + num2

        case 2:
            op1 = "restar"
            sol= num1 -num2
        case 3:
            op1= "multipliacr"
            sol= num1 * num2
        case 4:
            op1="dividir"
            if num2 != 0:
                sol= num1/num2
            else:
                sol="no se puede dividir entre 0"
    print("El resultado de ", op1, "es", sol)

def ej10():
    a = pideNum()
    b = pideNum()
    c = pideOp()
    calc(a, b, c)

def datos():
    print("Host -->", gethostname(), "\nIP de nuestra máquina -->", gethostbyname(gethostname()))
    return gethostname(), gethostbyname(gethostname())

def datos1():

    print(netifaces.interfaces())

def ej11():
    datos()
    datos1()

def randIP(hitza):
    sol=""
    match hitza.lower():
        case "a":
            sol = str(rt(0, 127))
            pass
        case "b":
            sol = str(rt(128, 191))
            pass
        case "c":
            sol = str(rt(191, 223))
            pass
    if len(sol)>0:
        sol += "." + str(rt(0, 255)) + "."+str(rt(0, 255)) +"."+str(rt(0, 255))
        '''return ipaddress.ip_address(sol)'''
        return sol
    return ""

def ej12():
    print(randIP("a"))
    print(randIP("b"))
    print(randIP("C"))







