# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np

X = np.zeros((10,10));

X[3,2] = 1;


def makeBigger(X):
    import numpy as np
    import operator
    Z = np.zeros(tuple(map(operator.add,X.shape,(1,2))))
    for i in range(0,X.shape[0]):
        for j in range(0,X.shape[1]):
            Z[i,j+1] = X[i,j]            
    return Z


def rule(X):
    X = makeBigger(X)
    for i in range(0,X.shape[0]):
        for j in range(0,X.shape[1]):
            if j<X.shape[0]-1 and i>0 and X[i-1,j] == 0 and X[i-1,j-1] == 0 and X[i-1,j+1] == 0:
                X[i,j] = 1
            elif j == X.shape[0]-1 and X[i-1,j] == 0 and X[i-1,j-1] == 0:
                X[i,j] = 1
            elif j == 0 and X[i-1,j] == 0 and X[i-1,j+1] == 0:
                X[i,j] = 1
            else:
                X[i,j] = 0
    return X

Z = np.ones((1,1))

print(rule(Z))