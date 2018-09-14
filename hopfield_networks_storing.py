import numpy as np
import random

############
#  Step 1  #
############
error_counter = 0
trial_counter = 0
patterns_number = 100

############
#  Step 2  #
############
#N = int(input("Choose N: "))
N = 100
bits = [-1, 1]
trials = 10000

for i in range(0, trials):
	patterns_list = np.zeros((patterns_number, N), dtype=int)
	for patern in patterns_list:
		for i in range(N):
			patern[i]=random.choice(bits)
	#print("inputs paterns")
	#print(patterns_list)

	weight_matrix = np.zeros((N,N), dtype=int)
	#print("## weight matrix")

	for patern in patterns_list:
		#print('patern')
		#print(patern)
		matrix_weight_of_x = np.zeros((N,N), dtype=int)
		for i in range(N):
			for j in range(N):
				if i==j:
					matrix_weight_of_x[i,j] = 0
				else:
					matrix_weight_of_x[i,j] = patern[i]*patern[j]
		#print(matrix_weight_of_x)
		weight_matrix = weight_matrix + matrix_weight_of_x
	#print(weight_matrix)

	#step4 choose randomly
	#print("## random patern picked randomly")
	randomNumber = random.randint(0, len(patterns_list)-1)
	#print(randomNumber)
	randomPatern = patterns_list[randomNumber-1]
	#print(randomPatern)

	#step5
	neuronNumber = random.randint(0, N-1)
	#print('## neuron')
	#print(neuronNumber)

	old = randomPatern[neuronNumber -1]

	#print("## weight matrix part")
	matrixRow = weight_matrix[neuronNumber -1]
	#print(matrixRow)

	total = 0
	#for bit in randomPatern:
	#	for component in matrixRow:
	#		total = total + (bit*component)
	for i in range(N):
		total = total + (randomPatern[i]*matrixRow[i])
		#print("randomPatern[i]*matrixRow[i] : "+ str(randomPatern[i]) + " + " + str(matrixRow[i]) + " = "+ str(total))

	new = np.sign(total)
	if new == 0:
		new = 1

	#print("## old")
	#print(old)
	#print("## new bit")
	#print(new)
	if old != new:
		error_counter=error_counter+1

	trial_counter = trial_counter+1

perror = (float(error_counter))/(float(trials))
print('## perror')
print(perror)