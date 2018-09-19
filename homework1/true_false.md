###The stochastic update rule for the Hopfield network is identical to the Metropolis algorithm. 
_true_

###That the energy cannot increase under the deterministic Hopfield dynamics is a consequence of the fact that the weights are symmetric. 
_true_
**"Note that Hebb’s rule yields symmetric weights, For symmetric
weights it follows that H cannot increase under the dynamics of the Hopfield
model.**"

###That the energy cannot increase under the deterministic Hopfield dynamics holds also when the thresholds are not zero. 
?

###Not all stored patterns are local minima of the energy function. 
_false_
**"If the cross-talk term causes errors for a certain stored pattern
that is fed into the network, then this pattern is not located at a minimum of the energy function. Conversely there may be minima that do not correspond
to stored patterns. Such states are referred to as
spurious states. The network may converge to spurious states, this is undesirable but inevitable"**
**"Here the patterns ... are not necessarily minima of H, because a maximal value of ... may be compensated by terms stemming from other patterns. But one can hope that this happens rarely when p is small (Section 2.2)"**
**"Stored patterns may be minima of the energy function (attractors), but they need not be"**

###In the limit of N→∞ the order parameter mμ can have more than one component of order unity, the other components are small. 
???
if we feed one of the stored patterns,
x^(1) for example, then we want the noisy dynamics to stay in the vicinity of x(1). This can only work if the noise is weakenough. Success is measured by the order parameter mμ
Now assume that m1≈m with m of order unity, and mμ≈0 for μ6=0.
Then the first term in the sum over μ dominates, provided that the small
terms do not add up to a contribution of order unity. This is the case if alpha = p/n

###One feeds a distorted pattern into the network by setting the neuron states equal to the bits in the pattern.
_false_
We need to multiply by the matrix row as well