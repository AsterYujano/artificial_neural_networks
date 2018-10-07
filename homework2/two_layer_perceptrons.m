clear all;
close all;
clc;
training_set_init = csvread("training_set.csv");
training_set = training_set_init(:,1:2);
Nmu = size(training_set,1);
target = training_set_init(:,3:3);

%%%%%%%%%%%%
%  To init %
%%%%%%%%%%%%
learning_rate = 0.01;
M1 = 1; % number of neurons on layer one
M2 = 1; 
T = 10^5;

thresholdsM1 = zeros(1,M1);
thresholdsM2 = zeros(1,M2);
threshold = 0;
%you can generate N random numbers in the interval (a,b) with the formula r = a + (b-a).*rand(1,N). 
weights1 = -0.2 + (0.2-(-0.2))*rand(M1,2);
weights2 = -0.2 + (0.2-(-0.2))*rand(M2,M1);
weights3= -0.2 + (0.2-(-0.2))*rand(1,M2);

for repetition = 1:T
    mu = randi([1 Nmu]);

    V0 = zeros(1,2);
    for k = 1:2
        V0(1,k) = training_set(mu,k);
    end
    V1 = zeros(1, M1);
    V2 = zeros(1, M2);

    %%%%%%%%%%%%%%%%%%%
    % Propage forward %
    %%%%%%%%%%%%%%%%%%%

    %Layer one
    for neuron = 1:M1
        for input = 1:2
            V1(neuron) = V1(neuron) + weights1(neuron,input)*V0(input);
        end
        V1(neuron) = tanh(V1(neuron) - thresholdsM1(neuron));
    end

    %Layer two
    for neuron = 1:M2
        for input = 1:M1
            V2(neuron) = V2(neuron) + weights2(neuron,input)*V1(input);
        end
        V2(neuron) = tanh(V2(neuron) - thresholdsM2(neuron));
    end

    %output final
    local_field = 0;
    for input = 1:M2
        local_field = local_field + weights3(input)*V2(input);
    end
    local_field = local_field - threshold;
    output = tanh(local_field);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Propage backward errors %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    errorV1 = zeros(1, M1);
    errorV2 = zeros(1, M2);

    % compute error for ouput
    error_o = (1 - (output)^2) * (target(mu)-output);

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
    for j = 1:2
       for i = 1:M1
        weights1(i,j) = weights1(i,j) + ( learning_rate * errorV1(i) + V0(j) );
        thresholdsM1(i) = thresholdsM1(i) - ( learning_rate * errorV1(i));
       end
    end

    %layer two
    for j = 1:M1
       for i = 1:M2
        weights2(i,j) = weights2(i,j) + ( learning_rate * errorV2(i) + V1(j) );
        thresholdsM2(i) = thresholdsM2(i) - ( learning_rate * errorV2(i));
       end
    end

    %output
    for j = 1:M2
        weights3(j) = weights2(j) + ( learning_rate * error_o + V2(j) );
        threshold = threshold - ( learning_rate * error_o);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Training validation Set %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if mod(repetition,10000)==0
        validation_set = csvread("validation_set.csv");
        validation_training_set = validation_set(:,1:2);
        validation_target = training_set_init(:,3:3);
        Nmu_val = size(validation_set,1);
        C = 0;

        for mu = 1:Nmu_val
            V0_val = zeros(1,2);
            for k = 1:2
                V0_val(1,k) = validation_training_set(mu,k);
            end
            V1_val = zeros(1, M1);
            V2_val = zeros(1, M2);

            %Layer one
            for neuron = 1:M1
                for input = 1:2
                    V1_val(neuron) = V1_val(neuron) + weights1(neuron,input)*V0_val(input);
                end
                V1_val(neuron) = tanh(V1_val(neuron) - thresholdsM1(neuron));
            end

            %Layer two
            for neuron = 1:M2
                for input = 1:M1
                    V2_val(neuron) = V2_val(neuron) + weights2(neuron,input)*V1_val(input);
                end
                V2_val(neuron) = tanh(V2_val(neuron) - thresholdsM2(neuron));
            end

            %output final
            local_field = 0;
            for input = 1:M2
                local_field = local_field + weights3(input)*V2_val(input);
            end
            local_field = local_field - threshold;
            output = tanh(local_field);

            if output == 0
                output = 1;
            end

            output = sign(output);
            test = validation_target(mu);

            C = C + (1/(2*Nmu_val)) * (abs(output - validation_target(mu)));
        end
        disp(C*100 + " %");
    end
end





