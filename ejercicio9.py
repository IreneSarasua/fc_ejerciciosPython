def pideNum():
    while True:
        try:
            a = int(input("Introduce un número --> "))
            return a
        except:
            print("Por favor que sea un número")

a = pideNum()
print(a)