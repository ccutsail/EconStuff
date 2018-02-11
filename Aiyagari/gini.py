'''
File contains a function to calculate a Gini coefficient
'''
def ginicoefficient(population, value):
    '''
    This function calculates and returns a Gini coefficient from a population and a value measure
    Ex
    '''
    import matplotlib.pyplot as plt
    import numpy as np

    population = np.asarray(population)
    value = np.asarray(value)
    population = np.insert(population, 0, 0, axis=0)
    value = np.insert(value, 0, 0, axis=0)
    dprod = np.multiply(population, value)
    indices = np.argsort(population)
    value = value[indices]
    dprod = dprod[indices]
    population = population[indices]
    plt.scatter(population, value)
    value = np.cumsum(value)
    dprod = np.cumsum(dprod)

    plt.show()
    
    popfrac = population/population[-1]
    dpfrac = dprod/dprod[-1]

    gini = 1 - sum(np.multiply(sum((dpfrac[2:len(dpfrac)-1]+dpfrac[3:len(dpfrac)])), np.diff(popfrac)))



    return [gini, value, dprod]
