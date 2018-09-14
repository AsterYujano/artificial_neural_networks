import numpy as np
import random

############
#  Step 1  #
############
error_counter = 0
trial_counter = 0
patterns_number = 12

############
#  Step 2  #
############
#N = int(input("Choose N: "))
N = 9
bits = [-1, 1]
#random.choice(bits)

print("#### Patterns list #####")
patterns_list = np.zeros((patterns_number, N), dtype=int)
for i in range(len(patterns_list)):
	for j in range(N):
		patterns_list[i,j] = random.choice(bits)

print(patterns_list)

############
#  Step 3  #
############
def create_W(x):
    w = np.zeros([len(x),len(x)], dtype=int)
    for i in range(len(x)):
        for j in range(i,len(x)):
            if i == j:
                w[i,j] = 0
            else:
                w[i,j] = x[i]*x[j]
                w[j,i] = w[i,j]
    return w0

print("#### W ####")
W = np.zeros((N, N), dtype=int)
print(create_W([1, 1, -1]))

print(W)