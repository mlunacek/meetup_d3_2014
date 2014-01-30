#!/usr/bin/env python

import pandas as pd
import os
import smash

# Parallel coordinates

# Read in some iris data, create parallel coordinates plot
iris = pd.read_csv(os.path.join('data','iris.csv'))
smash.parallel(data=iris, name='iris_parallel').create()

# Cars example
cars = pd.read_csv(os.path.join('data','cars.csv'))
smash.parallel(data=cars, name='cars_parallel').create()


# Scatter plot
#Three columns, with the third being the color.
subset = cars[['economy (mpg)','weight (lb)','cylinders']]
smash.scatter(data=subset, name='cars_scatter').create()

#Collide
smash.collide(name='collide').create()