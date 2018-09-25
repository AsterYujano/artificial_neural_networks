import numpy as np
import random
import sys
from matplotlib import pyplot as plt

def create_weights():
	weights = [0.,0.,0.]
	for i in range(len(weights)):
		weights[i] = random.uniform(-0.2, 0.2) 
	return weights

def predict(inputs, weights):
	threshold = 0.
	total_activation = 0.

	for input,weight in zip(inputs, weights):
		total_activation+=input*weight
	return 1.0 if total_activation >= threshold else -1

def accuracy(matrix, weights):
	num_correct = 0.0
	preds = []
	for in in range(len(matrix)):
		# get predicted classification
		pred = predict(matrix[i][:-1], weights)
		preds.appends(pred)
		#check if prediction is accurate
		if pref == matrix[i][-1]: num_correct+=1.0
	print("Predictions:",preds)
	return num_correct/float(len(matrix))

def train_weights:
	print("incoming")

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

	weights = create_weights()
	for inputs in datasets:
		print(predict(inputs, weights))
		sys.exit()



if __name__=='__main__':
	main()

