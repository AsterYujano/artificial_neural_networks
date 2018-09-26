import numpy as np
import random
import sys
from matplotlib import pyplot as plt

datasets = [
	#   x1,x2,x3,x4
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
targets = [
 [1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, -1, -1, -1, 1],
 [1, 1, -1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, -1],
 [1, 1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1],
 [1, 1, 1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 1],
 [-1, -1, -1, 1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1],
 [1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, -1, -1, -1]
]
weights = [0.,0.,0.]
for i in range(len(weights)):
	weights[i] = random.uniform(-0.2, 0.2)
threshold = random.uniform(-1., 1.)
learning_rate = 0.02

def guess(inputs, weights):
	total_activation = 0.
	for input,weight in zip(inputs, weights):
		total_activation+=input*weight
	total_activation = total_activation - threshold
	return np.tanh(0.5*total_activation)
	
def train(inputs, target, learning_rate, weights):
	error = target - guess(inputs, weights)
	for i in range(len(weights)):
		weights[i] += error * inputs[i] * learning_rate
	return weights

def main(weights, verbose=False):
	targetsA = targets[5]

	for inputs in datasets:
		#Take the right target in A for the inputs
		target = targetsA[datasets.index(inputs)]
		
		for i in range(10000):
			old_weights = [0.,0.,0.]
			for j in range(len(weights)):
				old_weights[j] = weights[j]

			weights = train(inputs, target, learning_rate, weights)
			if old_weights == weights:
				if verbose: print("i = "+str(i)+"; trained.")
				break

	#Try a guess with good new updated weights	
	for inputs in datasets:
		guessTamp = 0
		target = targetsA[datasets.index(inputs)]
		if guess(inputs, weights) >= 0:
			guessTamp = 1
		else:
			guessTamp = -1
		if target == guessTamp:
			print("(+) Success")
		else: 
			print("(+) Fail")
	print("---------")



if __name__=='__main__':
	for i in range(10):
		weights = [0.,0.,0.]
		for i in range(len(weights)):
			weights[i] = random.uniform(-0.2, 0.2)
		threshold = random.uniform(-1., 1.)
		learning_rate = 0.02
		main(weights)