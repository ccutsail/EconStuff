import numpy as np
import matplotlib.pyplot as plt

def generateData(n, genType="normal"):
    if(genType=="normal"):
        return np.random.randn(n)
    else:
        return np.random.uniform(-1,1,n)

# plt.plot(generateData(100,"u"))
# plt.plot(generateData(100))
# plt.show()

def factorial(n):
    val = 1
    for i in range(1,n+1):
        val = val*i
    return val

def binomialRV(n,p):
    unifVec = np.random.uniform(0,1,n)
    iter = 0
    for i in unifVec:
        if i > p:
            iter += 1 
    return iter


def monteCarloPi(n):
    unifVec = [np.random.uniform(0,1,n),np.random.uniform(0,1,n)]
    iter = 0
    for i in range(len(unifVec[0])):
        if np.sqrt((unifVec[0][i]-0.5)**2+(unifVec[1][i]-0.5)**2) < 0.5:
            iter += 1 
    return iter/n*4

def coinSeries():
    unifVec = np.random.uniform(0,1,10)
    binVec = [None]*10
    i = 0
    for real in unifVec:
        if real >= 0.5:
            binVec[i] = 1
        else: 
            binVec[i] = 0
    return set([1,1,1]).issubset(binVec)

def timeSeries(T=100,alpha=0.9):
    X = [0]*T
    for i in range(T):
        if i > 0:
            X[i] = X[i-1]*alpha + np.random.randn()
    return X


for alpha in [0,0.8,0.98]:
    plt.plot(timeSeries(200,alpha), label='alpha = %.2f'%(alpha,))
    

plt.legend()
plt.show()
