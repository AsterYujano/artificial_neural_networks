import numpy as np

x = np.array([1, 4, 5, 8], float)

inputs = np.array([
		[-1, -1, -1, -1, -1, 1, 1, -1, -1],
		[-1, -1, 1, -1, -1, -1, -1, 1, -1],
		[-1, -1, -1, -1, -1, 1, -1, -1, -1]
	])
def printInputs():
	n = 1
	for input in inputs:
		print("[+] input "+str(n))
		print(input)
		n=n+1

def create_W(x):
    if len(x.shape) != 1:
        print("The input is not vector")
        return
    else:
        w = np.zeros([len(x),len(x)], dtype=int)
        for i in range(len(x)):
            for j in range(i,len(x)):
                if i == j:
                    w[i,j] = 0
                else:
                    w[i,j] = x[i]*x[j]
                    w[j,i] = w[i,j]
    return w

# en argument on donne les paterns a store, cad x1 et x2 dans l'exo
def store(array_paterns_to_store):
	n = 1
	for input in array_paterns_to_store:
		if n != 1:
			weights = np.array(create_W(input))
		n=n+1
	print(weights)



paterns = np.array([
		[-1, -1, -1, -1, -1, 1, 1, -1, -1],
		[-1, -1, 1, -1, -1, -1, -1, 1, -1],
	])
store(paterns)

#for input in inputs:
#		print(create_W(input))

#pour selectionner une colonne dans une matrice :
# A = data[:,2]

	

