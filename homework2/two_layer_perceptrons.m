clear all;
close all;
clc;
training_set_init = csvread("training_set.csv");
training_set = training_set_init(:,1:2);
Nmu = size(training_set,1);
target = training_set_init(:,3:3);
validation_set = csvread("validation_set.csv");

%initialise weights and threshold
%t  = theta
% t t
% t t
% t 0 <- output
thresholds = zeros(3,2);
% w w
% w w
weights1 = -0.2 + (0.2-(-0.2))*rand(2,2);
weights2 = -0.2 + (0.2-(-0.2))*rand(2,2);
weights3= -0.2 + (0.2-(-0.2))*rand(1,2);


mu = randi([1 Nmu]);
outputsIntermediaires = zeros(2,2);
inputs = zeros(3,2);
for k = 1:2
    inputs(1,k) = training_set(mu,k);
end

%Layer one
hiddenlayer = 1;
weights = weights1;
for neuron = 1:2
    for input = 1:2
        outputsIntermediaires(hiddenlayer,neuron) = outputsIntermediaires(hiddenlayer,neuron) + weights(neuron,input)*inputs(hiddenlayer,input);
    end
    outputsIntermediaires(hiddenlayer,neuron) = tanh(outputsIntermediaires(hiddenlayer,neuron) - thresholds(neuron));
end
for m = 1:2
    inputs(hiddenlayer+1,m) = outputsIntermediaires(hiddenlayer,m);
end

%Layer two
hiddenlayer = 2;
weights = weights2;
for neuron = 1:2
    for input = 1:2
        outputsIntermediaires(hiddenlayer,neuron) = outputsIntermediaires(hiddenlayer,neuron) + weights(neuron,input)*inputs(hiddenlayer,input);
    end
    outputsIntermediaires(hiddenlayer,neuron) = tanh(outputsIntermediaires(hiddenlayer,neuron) - thresholds(neuron));
end
for m = 1:2
    inputs(hiddenlayer+1,m) = outputsIntermediaires(hiddenlayer,m);
end

%output final
local_field = 0;
for input = 1:2
    local_field = local_field + weights3(input)*inputs(3, input);
end
local_field = local_field - thresholds(3, 1);
output = tanh(local_field);

% compute error for ouput
error_o = (1 - (output)^2) * (target(mu)-output);

% error hidden layer 2
error_hidden_layer_2 = zeros(1,2);
error_hidden_layer_2(1) = error_o * poid * outputIntermediaires(2,
error_hidden_layer_2(2) = error_o * poid * outputIntermediaires(2,

% error hidden layer 1







% function [outputsIntermediaires] = computeNeuronsOfOnelayer(hiddenlayer,outputsIntermediaires,weights,thresholds, inputs)
%     % 1 layer with 2 neurons
%     for neuron = 1:2
%         for input = 1:2
%             outputsIntermediaires(hiddenlayer,neuron) = outputsIntermediaires(hiddenlayer,neuron) + weights(neuron,input)*inputs(hiddenlayer,input);
%         end
%         outputsIntermediaires(hiddenlayer,neuron) = tanh(outputsIntermediaires(hiddenlayer,neuron) - thresholds(neuron));
%     end
% end


