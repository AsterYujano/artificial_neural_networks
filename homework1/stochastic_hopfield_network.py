import numpy as np
import random
import math
import sys

patterns_number = 5
noise = 2
updates = 10000
N = 200
bits = [-1, 1]
sumM1 = 0


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
	firstSum = 0
	secondSum = 0
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
	Xjbougepas = patterns_list[0]

	x1patern = np.zeros(N, dtype=int)
	for i in range(N):
			x1patern[i]=Xjbougepas[i]

	x1patern_previous = np.zeros(N, dtype=int)
	for i in range(N):
			x1patern_previous[i]=Xjbougepas[i]
	## todo : peut etre erreur copie et référence

	for update in range(updates):
		firstSum = 0
		print(update, end="\r")
		for neuronNumber in range(N):
			matrixRow = weight_matrix[neuronNumber]
			total = 0
			for i in range(len(x1patern)):
				total = total + (x1patern_previous[i]*matrixRow[i])
			x1patern[neuronNumber] = int(stochastic_dynamic(noise,total))

			## start order parameter calculation
			firstSum = firstSum + (x1patern[neuronNumber] * Xjbougepas[neuronNumber])
			#print("[+] : "+str((x1patern[neuronNumber] * Xjbougepas[neuronNumber])))

		firstSum = firstSum/N
		#print(update,end="\r")
		x1patern_previous = x1patern
		secondSum = secondSum + firstSum 
	m1 = secondSum/updates
	#print("m1 :"+ str(m1))
	#sys.exit()
	sumM1 = sumM1 + m1
	return sumM1


nbr_trials = 100
for i in range(nbr_trials):#100
	#print(i, end="\r")
	sum = process()
sum = sum/nbr_trials

print("# subM1")
print(sum)

#0.9392000000000006
#0.1272999999999999