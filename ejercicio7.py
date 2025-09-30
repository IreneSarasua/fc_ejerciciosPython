
def dddd():
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

dddd()
