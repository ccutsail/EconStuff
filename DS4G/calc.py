def gradDescent(theta, X, y, *kwargs):
    import numpy as np
    (np.dot(X,theta)-y)

def sigmoid(x):
    import numpy as np
    return 1/(1+np.exp(np.multiply(-1,[1,1,1])))
    
def finite_difference(x, f, stepsize = 0.0001):
    import numpy as np
    x = np.asarray(x)
    return (f(x+stepsize)-f(x-stepsize))/stepsize

def quadratic(x, a=1):
    return a * x ** 2

