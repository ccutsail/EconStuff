

# Posner model -- C = x + p(x)*[y +z + e(x,y,z)]
# i use p(x) is exponential with lambda = 0.75, and e(.) is
# CRS Cobb-Douglas with share parameter 1/3
# x is cost to prep contract, y is cost to litigate for contracting parties,
# z is cost of litigation for judiciary, and e(.) is error cost for
# when the judiciary messes up


def prob(x,lmda=0.75):
    return np.multiply(lmda,np.exp(np.multiply(-1*lmda,x)))

def cdouglas(x,y,z,sp1 = 1/3,sp2 = 1/3, sp3 = 1/3):
    return np.multiply(np.power(x,sp1),np.power(y,sp2),np.power(z,sp3))

def COST(x,y,z,lmda = 0.75,sp1=1/3,sp2=1/3,sp3=1/3):
    return x + prob(x,lmda)*(y+z+cdouglas(x,y,z,sp1,sp2,sp3))

import numpy as np

x = np.linspace(0,10)
y = np.linspace(0,50)
z = np.linspace(0,12)

import matplotlib.pyplot as plt

i_bin = np.linspace(0,3,6)
plt.subplots(2,2,figsize=(15,15))
for i in range(len(i_bin)-1):
    plt.subplot(2,2,1)
    plt.plot(x,COST(x,y,z,i_bin[i],1/3,1/3,1/3),label="λ = %d" %i)
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.ylabel("C")
plt.xlabel("x")
plt.title("The Effect of λ on C")

i_bin = np.linspace(0,1.9,6)

for i in range(len(i_bin)-1):
    plt.subplot(2,2,2)
    plt.plot(x,COST(x,y,z,0.75,i_bin[i],1/3,1/3),label="δ = %d" %i)
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.ylabel("C")
plt.xlabel("x")
plt.title("The Effect of δ on C")

for i in range(len(i_bin)-1):
    plt.subplot(2,2,3)
    plt.plot(x,COST(x,y,z,0.75,1/3,i_bin[i],1/3),label="γ = %d" %i)
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.ylabel("C")
plt.xlabel("x")
plt.title("The Effect of γ on C")

for i in range(len(i_bin)-1):
    plt.subplot(2,2,4)
    plt.plot(x,COST(x,y,z,0.75,1/3,1/3,i_bin[i]),label="η = %d" %i)
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
plt.ylabel("C")
plt.xlabel("x")
plt.title("The Effect of η on C")
plt.show()
plt.ion()
