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
    import scipy.integrate as scp
    plt_title_val = input("Enter a title for the Lorenz Curve plot: ")
    population = np.asarray(population)
    value = np.asarray(value)
    population = np.insert(population, 0, 0, axis=0)
    value = np.insert(value, 0, 0, axis=0)
    dprod = np.multiply(population, value)
    indices = np.argsort(value)
    value = value[indices]
    population = population[indices]
    
    vsum = np.cumsum(value)
    vprop = np.divide(vsum,sum(value))

    psum = np.cumsum(population)
    pprop = np.divide(psum,sum(population))

    indices = np.argsort(vprop)
    vprop = vprop[indices]
    pprop = pprop[indices]

    perfEqLine = np.linspace(0,1,num=len(pprop))

    
    popfrac = population/population[-1]
    dpfrac = dprod/dprod[-1]
    # the area of the box containing the lorenz curve is 1
    # between the line of perfect equality and the upper half of the box,
    # area is one half. we can calculate the area between the Lorenz
    # curve and the line of perfect inequality (the x-axis, in practice) 
    # and subtract it from 1/2 -- the area remaining after taking away the 
    # upper 1/2 of the box.
    # the formula:
    # 1/2 - 
    gini = 1/2-simple_quad(pprop, vprop)


    fig = plt.figure()
    ax1 = fig.add_subplot(111)


    ax1.scatter(pprop, vprop, s=1/5)
    ax1.plot(perfEqLine,perfEqLine, color='green')
    ax1.axhline(y=0, color='k',linestyle='--',linewidth=1)
    ax1.axvline(x=0, color='k',linestyle='--',linewidth=1)
    plt.title(plt_title_val)
    plt.tight_layout(pad=0, w_pad=0, h_pad=0)
    ax1.set_xlabel(str("Gini Coefficient: " + str(round(gini,4))))
    plt.gcf().subplots_adjust(bottom=0.15)
    plt.show()

    return gini


def simple_quad(xvals,yvals):
    intval = 0
    for i in range(1,len(xvals)):
        intval = intval + (xvals[i] - xvals[i-1])*yvals[i]
        intval = intval + 1/2*((yvals[i]-yvals[i-1])*(xvals[i] - xvals[i-1]))
        
    return intval