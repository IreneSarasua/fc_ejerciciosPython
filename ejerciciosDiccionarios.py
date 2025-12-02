import time
def ej1(dic):
    print(dic["cpu"])


def ej2(dic):
    dic["gpu"] = "Nvidia RTX5070"
    print(dic["gpu"])

def ej3(dic):
    if dic.get("ram") is not None:
        print("Este pc tiene ram")

def ej4(dic):
    dic["ram"] = "32GB"
    print(dic["ram"])

def ej5(dic):
    dic.pop("disco")
    print(dic.get("disco"))


def ej6(dic):
    dic["Pepon"]="699999999"
    dic["Pepe"]="600000000"
    dic.pop("Pepinillo")
    for clave in dic.keys():
        print(f"{clave} ")
    for valor in dic.values():
        print(f"{valor} ")

def ej7(dic):
    dic["ip"] ="192.168.1.50"
    dic["dns"] ="8.8.8.8"
    if dic.get("dns") is not None:
        print("Esta config tiene dns")

    for clave, valor in dic.items():
        print(f"{clave} -> {valor}")


def ej8(dic):
    dic["ordenadores"] +=1
    dic["switches"] -= 1
    dic["cables_red"] = 150
    cont =0
    for clave, valor in dic.items():

        if clave != "cables_red":
            cont += valor
    print(f"Num aparatos -> {cont}")


def ej9(dic):
    dic["shell"] = "/usr/bin/zsh"
    dic["grupos"] = ["sudo", "video"]

    for grupo in dic["grupos"]:
        print(grupo)

def ej10(dic):
    dic["habilidades"].append("rayo")
    dic["habilidades"].remove("hielo")
    print(f"Num habilidades -> {len(dic['habilidades'])}")
    for habilidad in dic["habilidades"]:
        print(habilidad)


def ej11(dic):
    dic["pc1"]["usuario"]= "laura"
    dic["pc3"] = {"ip": "172.20.131.102", "usuario": "sara"}
    for clave, valor in dic.items():
        print(f"{clave} -> ip: {valor['ip']} / usuario: {valor['usuario']}")

def ej12(dic):
    print(sum(dic.values()))
    num = 0
    max = []
    for clave, valor in dic.items():
        if valor >22:
            num += 1
        if len(max) == 0:
            max.append(valor)
            max.append(clave)
        elif max[0] == valor:
            max.append(clave)
        elif max[0] < valor:
            max = [valor, clave]
    print(f"Num ciclos con más de 22 -> {num}")
    print(f"Ciclo con más alumnos -> {max[1:]}")


def ej13(dic):
    opcion = -1
    while opcion != "5":
        print('''
        1. Añadir producto
        2. Borrar producto
        3. Buscar producto
        4. Mostrar todo
        5. Salir
        ''')
        opcion = input("Elige una opción --> ")
        match opcion:
            case "1":
                elem = input("Producto a añadir --> ")
                if dic.get(elem) is not None:
                    print("Ese producto ya existe")
                else:
                    try:
                        cant = int(input("Cantidad --> "))
                        dic[elem] = cant

                    except ValueError:
                        print("Error de conversión de dato.")
                    except:
                        print("Error")

            case "2":
                elem = input("Producto a borrar --> ")
                if dic.get(elem) is not None:
                    dic.pop(elem)
                else:
                    print("No encontrado")
            case "3":
                elem = input("Producto a buscar --> ")
                if dic.get(elem) is not None:
                    print('{0} -> {1}'.format(elem, dic[elem]))
                else:
                    print("No encontrado")
            case "4":
                for clave, valor in dic.items():
                    print(f"{clave} -> {valor}")
            case "5":
                print("Saliendo")
            case _:
                print("Opción incorrecta.")



def ej14(dic1, dic2):
    dic1.update(dic2)
    for clave, valor in dic1.items():
        print(f"{clave} -> {valor}")

def ej15(dic):
    dic["miercoles"].append("192.168.1.20")
    for clave, valor in dic.items():
        print(f"{clave}, num conexiones -> {len(valor)}")



if __name__ == '__main__':
    pc = {
        "ram": "24GB",
        "cpu": "i7",
        "disco": "1TB"
    }
    ej1(pc)
    ej2(pc)
    ej3(pc)
    ej4(pc)
    ej5(pc)

    agenda = {
        "Pepa": "612345678",
        "Pepinillo": "678543210",
        "Pepe": "666666666"
    }
    ej6(agenda)

    config = {
        "ip": "192.168.1.50",
        "mascara": "255.255.255.0",
        "gateway": "192.168.1.1"
    }
    ej7(config)

    inventario = {
        "ordenadores": 25,
        "switches": 3,
        "routers": 1
    }

    ej8(inventario)

    usuario = {
        "nombre": "ekaitz",
        "uid": 1001,
        "shell": "/bin/bash",
        "home": "/home/ekaitz"
    }

    ej9(usuario)

    pj = {
        "nombre": "Hechicero",
        "nivel": 4,
        "vida": 100,
        "habilidades": ["fuego", "hielo"]
    }

    ej10(pj)

    equipo = {
        "pc1": {"ip": "192.168.0.10", "usuario": "ana"},
        "pc2": {"ip": "192.168.0.11", "usuario": "carlos"}
    }
    ej11(equipo)

    ciclos = {
        "DAW": 25,
        "SMR": 20,
        "DAM": 22,
        "STI": 18
    }

    ej12(ciclos)

    almacen = {}

    ej13(almacen)

    a = {"ip": "10.0.0.5", "mascara": "255.0.0.0"}
    b = {"gateway": "10.0.0.1", "dns": "1.1.1.1"}

    ej14(a, b)

    historial = {
        "lunes": ["192.168.1.10", "192.168.1.14"],
        "martes": ["192.168.1.20"],
        "miercoles": []
    }

    ej15(historial)

    # Sobreescribir el print
    # i = 1
    # while i <= 100:
    #     print(f"\r{i}%", end='')#, flush=True)
    #     i += 1
    #     time.sleep(1)



