import numpy as np
import random
import sys
from matplotlib import pyplot as plt

def main():
	#    x1 , x2, x3, y
	datasets = [
		[-1,-1,-1,-1],
		[1,-1,-1,-1],
		[-1,1,-1,-1],
		[-1,-1,1,-1],
		[-1,-1,-1,1],
		[1,1,-1,-1],
		[1,-1,1,-1],
		[1,-1,-1,1],
		[-1,1,1,-1],
		[-1,1,-1,1],
		[-1,-1,1,1],
		[1,1,1,-1],
		[1,1,-1,1],
		[1,-1,1,1],
		[-1,1,1,1],
		[1,1,1,1]
	]

	plot(datasets)

	print("hey")

if __name__=='__main__':
	main()


###############""
def create_weights():
	weights = np.zeros(4)
	for i in range(len(weights)):
		weights[i] = random.uniform(-0.2, 0.2) 
	return weights
