import subprocess
from getmac import get_mac_address
import random
import re
import socket



def mac_aleatoria():
    return "00:%02x:%02x:%02x:%02x:%02x" % (
        random.randint(0, 255),
        random.randint(0, 255),
        random.randint(0, 255),
        random.randint(0, 255),
        random.randint(0, 255)
    )


def validar_mac(mac):
    return re.search(r"([0-9A-Fa-f]{2}[:]){5}[0-9A-Fa-f]{2}", mac)



def validar_interfaz(interfaz):
    interfaces = socket.if_nameindex()
    #print(interfaces)  # Devuelve una lista de tuplas
    # [(1, 'lo'), (2, 'eth0'), (3, 'eth1')]
    # Un posible planteamiento: recorrer la lista y comprobar en cada tupla:
    for i in interfaces:
        if interfaz in i[1]: return True
    return False


def cambiar(mac, interfaz):
    #mac = "1c:1b:0d:99:ac:cd"
    #interfaz = "eth1"

    print("MAC INICIAL --> ",get_mac_address(interface=interfaz))
    #deshabilitar
    subprocess.run(["ifconfig", interfaz, "down"])
    #cambiar direccion mac
    subprocess.run(["ifconfig", interfaz, "hw", "ether", mac])
    #habilitar interfaz
    subprocess.run(["ifconfig", interfaz, "up"])
    #mostrar
    #subprocess.run(["ifconfig", mac])
    print("MAC ACTUAL --> ",get_mac_address(interface=interfaz))

if __name__ == '__main__':
    print("")
    #cambiar()