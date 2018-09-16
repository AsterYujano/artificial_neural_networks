import numpy as np
import random
import math

############
#  Step 1  #
############
patterns_number = 5
noise = 2
updates = 10000
N = 200
bits = [-1, 1]

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

randomNumber = random.randint(0, len(patterns_list)-1)
x1patern = patterns_list[0]

def stochastic_dynamic(noise, total):
	calcul1 = -2*noise*total
	calcul2 = np.exp(calcul1)
	calcul = 1/(1+calcul2)
	return calcul

for i in range(updates):
	neuronNumber = random.randint(0, N-1)
	matrixRow = weight_matrix[neuronNumber -1]

	total = 0
	for i in range(N):
		total = total + (x1patern[i]*matrixRow[i])

	new = stochastic_dynamic(noise,total)
	if new == 0:
		new = 1

	x1patern[neuronNumber] = new
print(x1patern)



