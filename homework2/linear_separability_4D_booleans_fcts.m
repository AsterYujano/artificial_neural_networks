clear all;
close all;
clc;
inputs = csvread("input_data_numeric.csv");
inputs=inputs(:,2:5);
targetA = [1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, -1, -1, -1, 1];
targetB = [1, 1, -1, 1, 1, 1, -1, 1, -1, 1, 1, -1, 1, 1, 1, -1];
targetC = [1, 1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1, -1, -1, -1, -1];
targetD = [1, 1, 1, -1, 1, 1, 1, 1, -1, -1, -1, 1, 1, 1, -1, 1];
targetE = [-1, -1, -1, 1, -1, 1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1];
targetF = [1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, -1, -1, -1];

%modifie the target to try
target = targetD;

for repet = 1:10
    %you can generate N random numbers in the interval (a,b) with the formula r = a + (b-a).*rand(1,N). 
    threshold = -1 + (1-(-1))*rand(1,1);
    weights = -0.2 + (0.2-(-0.2))*rand(1,4);
    outputs= zeros(1,16);
   
    for trial = 1:10000
        mu = randi([1 16]);
        outputs = guess(weights, threshold, inputs, outputs, mu);
        H = energy(target, outputs);
        if H <0.15
            disp("Linearly separable");
            break;
        end
        weights = weight_updates(weights, target, outputs, inputs, mu);
        threshold = threshold_updates(target, outputs, threshold, mu);
    end
end

function [outputs] = guess(weights, threshold , inputs, outputs, mu)
    local_field = 0;
    for i = 1:4
        local_field = local_field + ( weights(1,i) * inputs(mu,i) );
    end
    outputs(1, mu) = tanh( 0.5*( local_field - threshold ));
end

function [weights] = weight_updates(weights, target, outputs, inputs, mu)
    learning_rate = 0.02;
    for n = 1:4
        weights(1,n) = weights(1, n) + learning_rate * ((target(mu)-outputs(mu))*inputs(mu, n));
    end
end

function [threshold] = threshold_updates(target, outputs, threshold, mu)
    learning_rate = 0.02;
    threshold = threshold - learning_rate*(target(mu)-outputs(mu));
end

function [H] = energy(target, outputs)
    H = 0;
    for j = 1:16
        H = H + (target(j)-outputs(j))^2;
    end
    H = H*0.5; 
end





%     calcul erreur
%     class_error(1, mu) = abs( sign(output) - target(1,mu) );
%     for j = 1:16
%         abs_class_error = abs_class_error + class_error(1,j);
%     end
%     abs_class_error = beta * abs_class_error;
% 
%     if abs_class_error == 0
%         disp("trial - "+trial+ " // Linearly separable");
%         break;
%     else
%         %disp(["Not Linearly separable : "+ abs_class_error]); ,
%     end


% for i = 1:nbr_inputs
%     weights(1,i) = weights(1,i) + (learning_rate*beta*(target(1,mu)-output) * (1-(output^2))*inputs(mu,i));
%     threshold = threshold + (learning_rate*beta*(target(1,mu)-output) * (1-(output^2)));
% end
