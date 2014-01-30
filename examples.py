#!/usr/bin/env python

import pandas as pd
import os
import smash

# Parallel coordinates
# Cars example
cars = pd.read_csv(os.path.join('data','cars.csv'))
smash.parallel(data=cars, name='cars_parallel').create()

#Collide
smash.collide(name='collide').create()

