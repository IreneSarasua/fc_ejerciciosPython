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

try:
    a = int(input("Introduce un número --> "))
    divisores(a)
    multiplos(a, 5)

except:
    print("Error")