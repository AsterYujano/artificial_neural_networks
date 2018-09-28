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
threshold = 0
learning_rate = 0.02
beta = 0.5

def guess(inputs, weights, threshold=threshold):
	total_activation = 0.
	for input,weight in zip(inputs, weights):
		total_activation+=input*weight
	total_activation = total_activation - threshold
	return np.tanh(beta*total_activation)

#Todo : chaque neuron a son Threshold, appliquer la formule de dtheta poru l'update
def train(inputs, target, learning_rate, weights, threshold):
	output = guess(inputs, weights, threshold)
	error = target - output
	for i in range(len(weights)):
		threshold += learning_rate * beta * error * (1 - (output)**2)
		weights[i] += learning_rate * beta * error * (1 - (output)**2) * inputs[i] 
	return weights, threshold

def main(weights, verbose=False):
	targetsA = targets[0]

	inputs = (datasets[random.randint(0, 15)])
	if verbose: print("inputs chosen : "+str(inputs))

	#Take the right target in A for the inputs
	target = targetsA[datasets.index(inputs)]
	threshold = random.uniform(-1., 1.) 
	#print("pre : "+str(threshold))
	for i in range(10000):
		old_weights = [0.,0.,0.]
		for j in range(len(weights)):
			old_weights[j] = weights[j]

		weights, threshold = train(inputs, target, learning_rate, weights, threshold)
		#print("updated : "+str(threshold))
		if old_weights == weights: break

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
	weights = [0.,0.,0.]
	for i in range(len(weights)):
		weights[i] = random.uniform(-0.2, 0.2)
	threshold = random.uniform(-1., 1.)
	learning_rate = 0.02

	for m in range(10): #todo 10^5

		main(weights, verbose=True)