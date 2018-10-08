# True-False Questions

## Different layers of a deep network learn at different speeds because their effects on the output are different. 
%%%%%%%%
% TRUE %
%%%%%%%%
Vanishing gradient problem

## Two hidden layers are sufficient to approximate any real-valued function with N inputs and one output in terms of a perceptron.
%%%%%%%%
% TRUE %
%%%%%%%%
In general, for N inputs, two hidden layers are sufficient, with 2N units in the first layer, and one unit per basis function in second layer.
"any real-valued"

## In minimisation with a Lagrange multiplier, the function multiplying the Lagrange multiplier must be equal to or larger than zero. 
are incorporated using Lagrange multipliers A and B (both positive)
%%%%%%%%
% FALSE% 
%%%%%%%%

## Using a stochastic path through weight space in backpropagation allows for the energy to increase in some updates.
%%%%%%%%
% True %
%%%%%%%%
si tu fais batch mode ça peut que descendre mais si tu fais stochastic comme tu prends qu'un seul pattern pour calculer les erreurs y a moyen que l'énergie remonte

"In backpropagation with batch training the energy can increase in an update." 
Is true. Step size! Unfortunately we programmed OpenTA to accept false as the answer.  

"It yields a stochastic path through weight and threshold space which may help to avoid getting stuck in local minima"
In practice, the stochastic gradient-descent dynamics may be too noisy

## Some of the functions with 5 Boolean valued inputs and one Boolean valued output are linearly separable.
%%%%%%%%
% True %
%%%%%%%%

## Weight decay helps against overfitting. 
%%%%%%%%
% TRUE %
%%%%%%%%
These two weight-decay schemes are referred to as regularisation schemes because they tend to help against overfitting.
The idea is that a network with smaller weights is more robust to the effect of noise. When the weights are small, then small changes in some of the patterns do not give a substantially different training result.  When the network has large weights, by contrast, it may happen that small changes in the input give significant differences in the training result that are difficult to generalise

## Using g(b)=bg(b) as activation function and setting all thresholds to zero in a multilayer perceptron allows you to solve some linearly inseparable problems.
%%%%%%%%%
% FALSE %
%%%%%%%%%
Gradient descent learning : by minimising an energy function using gradient descent.  This requires
differentiation, therefore we must choose a differentiable activation function.
The simplest choice is g(b)=b
"we discussed how a hidden layer helps to classify problems
that are not linearly separable"
"The thresholds are usually set to zero. The initial values of the thresholds
are not so critical, because thresholds are often learned more rapidly than
the weights, at least initially"

## The number of N-dimensional Boolean functions is larger than 2^N
There are 2^N inputs and the number of fucntions is 2^(2^N)
%%%%%%%%
% TRUE %
%%%%%%%%

## Nesterov's accelerated gradient scheme is often more efficient than the simple momentum scheme because the weighting factor of the momentum term increases as a function of iteration number. 
%%%%%%%%%
% FALSE %
%%%%%%%%%