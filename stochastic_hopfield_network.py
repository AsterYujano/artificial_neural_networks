import numpy as np
import random
import math
import sys

patterns_number = 5
noise = 2
updates = 100
N = 200
bits = [-1, 1]
sumM1 = 0

###########
#Functions#
###########
def stochastic_dynamic(noise, total):
	### todo : UNDERSTAND HOW TO GET -1 et 1
	gamma = -2*noise*total
	response = 1/(1+math.exp(gamma))
	stochastic_dyn = np.random.choice([1, -1], p=[round(response,3), round(1-response,3)])
	return stochastic_dyn

def process():
	global sumM1
	###########
	# Storing #
	###########
	patterns_list = np.zeros((patterns_number, N), dtype=int)
	for patern in patterns_list:
		for i in range(N):
			patern[i]=random.choice(bits)

	weight_matrix = np.zeros((N,N), dtype=int)

	for patern in patterns_list:
		matrix_weight_of_x = np.zeros((N,N), dtype=int)
		for i in range(N):
			for j in range(N):
				if i==j:
					matrix_weight_of_x[i,j] = 0
				else:
					matrix_weight_of_x[i,j] = patern[i]*patern[j]
		weight_matrix = weight_matrix + matrix_weight_of_x

	weight_matrix = (1/N)*weight_matrix

	##############
	# Feeding X1 #
	##############
	randomNumber = random.randint(0, len(patterns_list)-1) #0 to 4
	x1patern = patterns_list[0]

	for i in range(updates):
		for neuronNumber in range(len(x1patern)):
			matrixRow = weight_matrix[neuronNumber]
			total = 0
			for i in range(0,len(x1patern)):
				total = total + (x1patern[i]*matrixRow[i])
			x1patern[neuronNumber] = int(stochastic_dynamic(noise,total))

	print(x1patern)

	m1 = (x1patern)/updates
	sumM1 = sumM1 + m1

for i in range(3):
	process()
print("# subM1")
print(sumM1)