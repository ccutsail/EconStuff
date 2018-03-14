

def dotProd(x,y):
    iter = 0
    for a,b in zip(x,y):
        iter += a*b
    return iter

sum([1 for i in range(1,101) if i%2 == 0])

pairs = ((2, 5), (4, 2), (9, 8), (12, 10))
sum([1 for i in range(0,len(pairs)) if pairs[i][0]%2 == 0 and pairs[i][1]%2 == 0])

p = lambda x,coefficients: sum([a*x**k for k,a in enumerate(coefficients)])

uppercaseCounter = lambda inputString: sum([1 for i,a in enumerate(inputString) if a == inputString.upper()[i]])


' cheated on this one '
def seqChecker(seq_a,seq_b):
    check = True
    for a in seq_a:
        if a not in seq_b:
            check = False
    return check
    



def linApprox(f,a,b,n,x):
    pointList = [a + (b-a)/n*i for i in range(0,n+1)]
    # TOO MANY FLOPS !!!!! n+2 function evaluations !!!!!!!!!!!!
    funcPointList = [f(k) for k in pointList]
    xLessThan = min([i for i,a in enumerate(pointList) if x <= a])
    xGreaterThan = xLessThan - 1
    return funcPointList[xGreaterThan] + (funcPointList[xLessThan] - funcPointList[xGreaterThan])/(pointList[xLessThan]-pointList[xGreaterThan])*(x-pointList[xGreaterThan])


# better way, stealing a bit from Stachurski and Sargent ...
# still not great, because xLessThan is still comparing n values and fully enumerating pointList

def linTerp(f,a,b,n,x):
    pointList = [a + (b-a)/n*i for i in range(0,n+1)]
    xLessThan = min([i for i,a in enumerate(pointList) if x <= a])
    xGreaterThan = xLessThan - 1
    return f(pointList[xGreaterThan]) + (f(pointList[xLessThan]) - f(pointList[xGreaterThan]))/(pointList[xLessThan]-pointList[xGreaterThan])*(x-pointList[xGreaterThan])


f = lambda x: x**2
x = 2.78123
a = 0
b = 5
n = 100000
