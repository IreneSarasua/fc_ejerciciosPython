from _socket import gethostname, gethostbyname
import netifaces

def datos():
    print("Host -->", gethostname(), "\nIP de nuestra máquina -->", gethostbyname(gethostname()))
    return gethostname(), gethostbyname(gethostname())

def datos1():

    print(netifaces.interfaces())
datos()
datos1()