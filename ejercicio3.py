import  datetime

try:
    nombre = input("Escribe un nombre: ")
    edad = int(input("Escribe la edad: "))


    print("Hola", nombre,"naciste en el año", datetime.datetime.now().year -edad)
except:
    print("Error")

