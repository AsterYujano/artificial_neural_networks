clear all;
close all;
clc;
training_set_init = csvread("training_set.csv");
training_set = training_set_init(:,1:2);
Nmu = size(training_set,1);
target = training_set_init(:,3:3);

validation_set = csvread("validation_set.csv");
validation_training_set = validation_set(:,1:2);
validation_target = training_set_init(:,3:3);
Nmu_val = size(validation_set,1);

%%%%%%%%%%%%
%  To init %
%%%%%%%%%%%%
%eta = learnng rate
eta = 0.02;
M1 = 8; % number of neurons on layer one
M2 = 4; 
T = 10^8;
T_repet = 10^6;

thresholdsM1 = zeros(1,M1);
thresholdsM2 = zeros(1,M2);
threshold = 0;

weights1 = randn(M1,2);
weights2 = randn(M2,M1);
weights3 = randn(1,M2);


for repetition = 1:T
    mu = randi([1 Nmu]);

    V0 = zeros(1,2);
    for k = 1:2
        V0(1,k) = training_set(mu,k);
    end
    local_field = 0;
   
    V1 = zeros(1, M1);
    V2 = zeros(1, M2);
    %%%%%%%%%%%%%%%%%%%
    % Propage forward %
    %%%%%%%%%%%%%%%%%%%

    %Layer one
    V1 = feeding(2,M1, V1, V0, weights1, thresholdsM1);

    %Layer two
    V2 = feeding(M1, M2, V2, V1, weights2, thresholdsM2);

    %output final
    output = feeding(M2, 1, local_field, V2, weights3, threshold);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Propage backward errors %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    errorV1 = zeros(1, M1);
    errorV2 = zeros(1, M2);

    % compute error for ouput
    local_field = local_field - threshold;
    error_o = (1 - (output)^2) * (target(mu) - output);

    %error Layer two
    for neuron = 1:M2
        errorV2(neuron) = error_o * weights3(neuron) * (1 - (V2(neuron))^2);
    end

    %error layer one
    for neuron = 1:M1
        for i = 1:M2
            errorV1(neuron) = errorV1(neuron) + ( errorV2(i) * weights2(i,neuron) * (1 - (V1(neuron))^2));
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % update weights & thresholds %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %layer one
    [weights1, thresholdsM1] = update(2, M1, weights1, thresholdsM1, eta, errorV1, V0);

    %layer two
    [weights2, thresholdsM2] = update(M1, M2, weights2, thresholdsM2, eta, errorV2, V1);

    %output
    [weights3, threshold] = update(M2, 1, weights3, threshold, eta, error_o, V2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Training validation Set %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(repetition,T_repet)==0
        C = 0;
        for mu = 1:Nmu_val
            V0_val = zeros(1,2);
            for k = 1:2
                V0_val(1,k) = validation_training_set(mu,k);
            end
            V1_val = zeros(1, M1);
            V2_val = zeros(1, M2);

            %Layer one
            V1_val = feeding(2,M1, V1_val, V0_val, weights1, thresholdsM1);
            
            %Layer two
            V2 = feeding(M1, M2, V2_val, V1_val, weights2, thresholdsM2);

            %output final
            V3 = 0;
            output = feeding(M2, 1, V3, V2_val, weights3, threshold);

            output = sign(output);
            
            C = C + (1/(2*Nmu_val)) * abs(output - validation_target(mu));
        end
        disp(C*100 + " %");
        if C<0.12
            disp(C*100 + " %");
            return
        end
    end
end

% csvwrite("t3.csv",threshold);
% csvwrite("t2.csv",thresholdsM2);
% csvwrite("t1.csv",thresholdsM1);
% csvwrite("w1.csv",weights1);
% csvwrite("w2.csv",weights2);
% csvwrite("w3.csv",weights3);

% Size 1 is the size of the first layer from left to right
function neurons = feeding(size1, size2, neurons,previous_neurons, weights, thresholds)
    for neuronNumber = 1:size2
        local_field = 0;
        for input = 1:size1
            local_field = local_field + weights(neuronNumber,input)*previous_neurons(input);
        end
        neurons(neuronNumber) = tanh(local_field - thresholds(neuronNumber));
    end
end

function [weights, thresholds] = update(size1, size2, weights, thresholds, eta, error, neurones)
    for i = 1:size2
        for j = 1:size1
            weights(i,j) = weights(i,j) + ( eta * error(i) * neurones(j) );
        end
    thresholds(i) = thresholds(i) - ( eta * error(i));
    end
end
