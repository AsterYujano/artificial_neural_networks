import numpy as np
import random
import math
import sys

patterns_number = 5
noise = 2
updates = 1000 #todo modify
N = 200
bits = [-1, 1]
sumM1 = 0
firstSum = 0
secondSum = 0

###########
#Functions#
###########
def stochastic_dynamic(noise, total):
	gamma = -2*noise*total
	response = 1/(1+math.exp(gamma))
	stochastic_dyn = np.random.choice([1, -1], p=[round(response,3), round(1-response,3)])
	return stochastic_dyn

def process():
	global sumM1
	global firstSum
	global secondSum
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
	x1patern = patterns_list[0]
	Xj = patterns_list[0]

	for update in range(updates):
		for neuronNumber in range(len(x1patern)):
			matrixRow = weight_matrix[neuronNumber]
			total = 0
			for i in range(len(x1patern)):
				total = total + (x1patern[i]*matrixRow[i])
			x1patern[neuronNumber] = int(stochastic_dynamic(noise,total))

			## start order parameter calculation
			firstSum = firstSum + (x1patern[neuronNumber] * Xj[neuronNumber])
		firstSum = firstSum/N
		#print(update,end="\r")

		secondSum = secondSum + firstSum 
	m1 = secondSum/updates
	print("m1 :"+ str(m1))
	#sys.exit()
	sumM1 = sumM1 + m1
	return sumM1



for i in range(2):#100
	#print(i, end="\r")
	sum = process()
sum = sum/2

print("# subM1")
print(sum)