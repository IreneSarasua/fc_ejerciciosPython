import funciones
import argparse
from termcolor import colored as clrd
from pyfiglet import Figlet as fglt


def crear_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("-m", dest="mac", help="Direccion MAC")
    parser.add_argument("-i", dest="interfaz", help="Interfaz de red")
    (opciones) = parser.parse_args()
    if not opciones.mac or opciones.interfaz:
         parser.error("Introduce una argumentos validos")
    return opciones

if __name__ == '__main__':

    # CREAR PARSER
    opciones = crear_parser()
    f = fglt(font='standard')

    print(clrd(f.renderText("CAMBIO DE MAC"), 'blue'))
    print(clrd("".center(50, "#"), 'green'))


    if opciones.mac == "a":
        opciones.mac = funciones.mac_aleatoria()
    if funciones.validar_mac(opciones.mac) and funciones.validar_interfaz(opciones.interfaz):
        funciones.cambiar(opciones.mac, opciones.interfaz)






# ip a
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#     inet 127.0.0.1/8 scope host lo
#        valid_lft forever preferred_lft forever
#     inet6 ::1/128 scope host noprefixroute
#        valid_lft forever preferred_lft forever
# 2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
#     link/ether 18:d6:c7:03:3a:c6 brd ff:ff:ff:ff:ff:ff
# 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
#     link/ether 1c:1b:0d:98:ac:cd brd ff:ff:ff:ff:ff:ff
#     inet 172.20.131.102/16 brd 172.20.255.255 scope global noprefixroute eth1
#        valid_lft forever preferred_lft forever
#     inet6 fe80::fbcc:b458:f3d4:a5af/64 scope link noprefixroute
#        valid_lft forever preferred_lft forever
# 4: vmnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
#     link/ether 00:50:56:c0:00:01 brd ff:ff:ff:ff:ff:ff
#     inet 172.16.152.1/24 brd 172.16.152.255 scope global vmnet1
#        valid_lft forever preferred_lft forever
#     inet6 fe80::250:56ff:fec0:1/64 scope link proto kernel_ll
#        valid_lft forever preferred_lft forever
# 5: vmnet8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
#     link/ether 00:50:56:c0:00:08 brd ff:ff:ff:ff:ff:ff
#     inet 172.16.1.1/24 brd 172.16.1.255 scope global vmnet8
#        valid_lft forever preferred_lft forever
#     inet6 fe80::250:56ff:fec0:8/64 scope link proto kernel_ll
#        valid_lft forever preferred_lft forever