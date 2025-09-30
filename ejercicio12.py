from  random import randint as rt
import ipaddress


def randIP(hitza):
    sol=""
    match hitza.lower():
        case "a":
            sol = str(rt(0, 127))
            pass
        case "b":
            sol = str(rt(128, 191))
            pass
        case "c":
            sol = str(rt(191, 223))
            pass
    if len(sol)>0:
        sol += "." + str(rt(0, 255)) + "."+str(rt(0, 255)) +"."+str(rt(0, 255))
        return ipaddress.ip_address(sol)
    return ""

print(randIP("a"))
print(randIP("b"))
print(randIP("C"))
