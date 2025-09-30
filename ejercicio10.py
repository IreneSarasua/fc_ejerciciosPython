def pideNum():
    while True:
        try:
            a = int(input("Introduce un número --> "))
            return a
        except:
            print("Por favor que sea un número")

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
a = pideNum()
b = pideNum()
c = pideOp()
calc(a, b, c)

