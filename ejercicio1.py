try:
    a = int(input ("Escribe un número: "))
    print(a)
    a += 3
    print("El número es",a)
except IOError:
    print("Error de entada/salida")
except ValueError:
    print("Error de conversión de dato.")
except:
    print("Error")

