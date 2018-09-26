import numpy as np
import random
import sys
from matplotlib import pyplot as plt

datasets = [
	#   x1,x2,x3,y
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
weights = [0.,0.,0.]
for i in range(len(weights)):
	weights[i] = random.uniform(-0.2, 0.2)
learning_rate = 0.02

def guess(inputs, weights):
	total_activation = 0.
	for input,weight in zip(inputs, weights):
		total_activation+=input*weight
	return 1 if total_activation >= 0 else -1

def train(inputs, target, learning_rate, weights):
	error = target - guess(inputs, weights)
	#if error == 0: print("pas d erreur")
	for i in range(len(weights)):
		weights[i] += error * inputs[i] * learning_rate
	return weights

def main(weights, verbose=False):
	for inputs in datasets:
		for i in range(10000):
			target = inputs[3]

			old_weights = [0.,0.,0.]
			for j in range(len(weights)):
				old_weights[j] = weights[j]

			weights = train(inputs, target, learning_rate, weights)
			if old_weights == weights:
				if verbose: print("i = "+str(i)+"; trained.")
				break

	#Try a guess with good new updated weights	
	for inputs in datasets:
		print(guess(inputs, weights))

if __name__=='__main__':
	main(weights)

