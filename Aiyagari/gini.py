'''
File contains a function to calculate a Gini coefficient
'''
def ginicoefficient(population, value):
    '''
    This function calculates and returns a Gini coefficient from a population and a value measure
    Ex
    '''

    import numpy as np
    print(len(value), len(population))
    population = np.asarray(population)
    value = np.asarray(value)

    population = np.insert(population, 0, 0, axis=0)
    value = np.insert(value, 0, 0, axis=0)
    dprod = np.multiply(population, value)
    indices = np.argsort(population)

    value = value[indices-1]
    dprod = dprod[indices-1]

    value = np.cumsum(value)
    dprod = np.cumsum(dprod)

    popfrac = population/population[-1]
    dpfrac = dprod/dprod[-1]

    gini = 1 - np.multiply(sum((dpfrac[2:len(dpfrac)-1]+dpfrac[3:len(dpfrac)])), np.diff(popfrac))

    return gini
