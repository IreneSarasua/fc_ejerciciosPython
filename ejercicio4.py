def espar(num):
    return num%2 == 0

def mult3(num):
    return num%3 == 0

def losPares(num):
    for i in range(1, num):
        if espar(i):
            print(i)


num = int(input("Escribe un número: "))

print("Es par:", espar(num))
print("Es multiplo de 3:", mult3(num))
losPares(num)
