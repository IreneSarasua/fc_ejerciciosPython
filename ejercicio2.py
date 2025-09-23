def function(num):
    if not(isinstance(num, int)):
        '''raise TypeError'''
        return "error de tipo de dato"

    return 0 <= num <= 10

print(function(1))
print(function(-2))
print(function("a"))