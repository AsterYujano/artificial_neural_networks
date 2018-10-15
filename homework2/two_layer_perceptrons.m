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
learning_rate = 0.02;
M1 = 8; % number of neurons on layer one
M2 = 4; 
T = 10^8;
T_repet = 10^7;

thresholdsM1 = zeros(1,M1);
thresholdsM2 = zeros(1,M2);
threshold = 0;
%you can generate N random numbers in the interval (a,b) with the formula r = a + (b-a).*rand(1,N). 
% weights1 = -0.2 + (0.2-(-0.2))*rand(M1,2);
% weights2 = -0.2 + (0.2-(-0.2))*rand(M2,M1);
% weights3= -0.2 + (0.2-(-0.2))*rand(1,M2);

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
    for neuron = 1:M1
        for input = 1:2
            V1(neuron) = V1(neuron) + weights1(neuron,input)*V0(input);
        end
        V1(neuron) = V1(neuron) - thresholdsM1(neuron);
        V1(neuron) = tanh(V1(neuron));
    end

    %Layer two
    for neuron = 1:M2
        for input = 1:M1
            V2(neuron) = V2(neuron) + weights2(neuron,input)*V1(input);
        end
        V2(neuron) = V2(neuron) - thresholdsM2(neuron);
        V2(neuron) = tanh(V2(neuron));
    end

    %output final
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
    for i = 1:M1
        for j = 1:2
            weights1(i,j) = weights1(i,j) + ( learning_rate * errorV1(i) * V0(j) );
        end
        thresholdsM1(i) = thresholdsM1(i) - ( learning_rate * errorV1(i));
    end

    %layer two
    for i = 1:M2
        for j = 1:M1
        weights2(i,j) = weights2(i,j) + ( learning_rate * errorV2(i) * V1(j) );
        end
       thresholdsM2(i) = thresholdsM2(i) - ( learning_rate * errorV2(i));
    end

    %output
    for j = 1:M2
        weights3(j) = weights2(j) + ( learning_rate * error_o * V2(j) );
    end
    threshold = threshold - ( learning_rate * error_o);
    
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
            
            C = C + abs(output - validation_target(mu));
        end
        C = (1/(2*Nmu_val))*C;
        disp(C*100 + " %");
        if C<0.12
            return
        end
    end
end

csvwrite("t3.csv",threshold);
csvwrite("t2.csv",thresholdsM2);
csvwrite("t1.csv",thresholdsM1);
csvwrite("w1.csv",weights1);
csvwrite("w2.csv",weights2);
csvwrite("w3.csv",weights3);





