clear all;
close all;
clc;

[xTrain, tTrain, xValid, tValid, xTest, tTest] = LoadMNIST(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  FIRST NETWORK %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

training_set = xTrain;
Nmu = size(xTrain,1);
target = tTrain;

%%%%%%%%%%%%
%  To init %
%%%%%%%%%%%%
learning_rate = 0.02;
M1 = 8; % number of neurons on layer one
M2 = 4; 
T = 10^7;
T_repet = 10^6;

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
        validation_training_set = xTest;
        validation_target = tTest;
        Nmu_val = size(validation_training_set,1);
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

            C = C + (1/(2*Nmu_val)) * (abs(output - validation_target(mu)));
        end
        disp(C*100 + " %");
    end
end
 

% digit number 25081
%imshow(reshape(xTrain(:,25081),[28 28]));















function [xTrain, tTrain, xValid, tValid, xTest, tTest] = LoadMNIST(exerciseNumber)

% This MATLAB function is an adaptation of the function prepareData.m,
% copyrighted in 2018 by The MathWorks, Inc. It's intended use is for the
% course Artificial Neural Networks (FFR135/FIM720) at Chalmers University
% of Technology/University of Gothenburg, Gothenburg, Sweden, 2018.
%
%%%%%%%%%
% Input %
%%%%%%%%%
%
% exerciseNumber: A number that determines the format of the returned data.
% This number may be 1, 2, 3 or 4. See separate course material for a
% documentation.
%
%%%%%%%%%%
% Output %
%%%%%%%%%%
% 
% xTrain: The input patterns of the training set
% tTrain: The output patterns of the training set
% xValid: The input patterns of the validation set
% tValid: The output patterns of the validation set
% xTest: The input patterns of the test set
% tTest: The output patterns of the test set
% 
% The format of the output data depends on the in-argument provided as
% "exerciseNumber". See separate course material for a documentation.

if ismember(exerciseNumber,[1 2])
    array2DFormat = true;
elseif ismember(exerciseNumber,[3 4])
    array2DFormat = false;
else
    assert(false,'"Exercise number" must equal 1, 2, 3 or 4.');
end

% Check for the existence of the MNIST files and download them if necessary

mnistDir = 'mnist_data';
files = {   "train-images-idx3-ubyte",...
            "train-labels-idx1-ubyte",...
            "t10k-images-idx3-ubyte",...
            "t10k-labels-idx1-ubyte"  };

% boolean for testing if the files exist
% basically, check for existence of "data" directory
download = exist(fullfile(pwd, mnistDir), 'dir') ~= 7;

if download
    disp('Downloading files...')
    mkdir(mnistDir)
    webPrefix = "http://yann.lecun.com/exdb/mnist/";
    webSuffix = ".gz";

    filenames = files + webSuffix;
    for ii = 1:numel(files)
        websave(fullfile(mnistDir, filenames{ii}),...
            char(webPrefix + filenames(ii)));
    end
    disp('Download complete.')
    
    % unzip the files
    cd(mnistDir)
    gunzip *.gz
    
    % return to main directory
    cd ..
end

% Extract the MNIST images into arrays

disp('Preparing MNIST data...');

% Read headers for training set image file
fid = fopen(fullfile(mnistDir, char(files{1})), 'r', 'b');
magicNum = fread(fid, 1, 'uint32');
numImgs  = fread(fid, 1, 'uint32');
numRows  = fread(fid, 1, 'uint32');
numCols  = fread(fid, 1, 'uint32');

% Read the data part 
rawImgDataTrain = uint8(fread(fid, numImgs * numRows * numCols, 'uint8'));
fclose(fid);

% Reshape the data part into a 4D array
rawImgDataTrain = reshape(rawImgDataTrain, [numRows, numCols, numImgs]);
rawImgDataTrain = permute(rawImgDataTrain, [2,1,3]);
imgDataTrain(:,:,1,:) = uint8(rawImgDataTrain(:,:,:));

% Read headers for training set label file
fid = fopen(fullfile(mnistDir, char(files{2})), 'r', 'b');
magicNum  = fread(fid, 1, 'uint32');
numLabels = fread(fid, 1, 'uint32');

% Read the data for the labels
labelsTrain = fread(fid, numLabels, 'uint8');
fclose(fid);

% Process the labels
labelsTrain = categorical(labelsTrain);

% Read headers for test set image file
fid = fopen(fullfile(mnistDir, char(files{3})), 'r', 'b');
magicNum = fread(fid, 1, 'uint32');
numImgs  = fread(fid, 1, 'uint32');
numRows  = fread(fid, 1, 'uint32');
numCols  = fread(fid, 1, 'uint32');

% Read the data part 
rawImgDataTest = uint8(fread(fid, numImgs * numRows * numCols, 'uint8'));
fclose(fid);

% Reprocess the data part into a 4D array
rawImgDataTest = reshape(rawImgDataTest, [numRows, numCols, numImgs]);
rawImgDataTest = permute(rawImgDataTest, [2,1,3]);
imgDataTest = uint8(zeros(numRows, numCols, 1, numImgs));
imgDataTest(:,:,1,:) = uint8(rawImgDataTest(:,:,:));

% Read headers for test set label file
fid = fopen(fullfile(mnistDir, char(files{4})), 'r', 'b');
magicNum  = fread(fid, 1, 'uint32');
numLabels = fread(fid, 1, 'uint32');

% Read the data for the labels
labelsTest = fread(fid, numLabels, 'uint8');
fclose(fid);

% Process the labels
labelsTest = categorical(labelsTest);

disp('MNIST data preparation complete.');

% Split the MNIST training set into a validation set and a proper training set

rngState = rng; % store this state of the random number generator
rng(123); % set the random number generator
idxValidationSet = randperm(60000,10000);
isValidationSet = ismember(1:60000,idxValidationSet);
rng(rngState); % reset the random number generator to the original state

% Up to now, we have loaded precisely the data as the original
% prepareData.m function. The variables are:
% imgDataTrain, labelsTrain, imgDataTest, labelsTest

% Create our output sets
xTrain = imgDataTrain(:,:,:,not(isValidationSet));
tTrain = labelsTrain(not(isValidationSet));
xValid = imgDataTrain(:,:,:,isValidationSet);
tValid = labelsTrain(isValidationSet);
xTest = imgDataTest;
tTest = labelsTest;

if ~array2DFormat
    return;
end

% Change format of output sets

xTrain = double(xTrain);
tTrain = double(tTrain);
tmp = zeros(10,50000);
for i = 1:50000
    tmp(tTrain(i),i) = 1;
end
tTrain = tmp;
xTrain = reshape(xTrain,[784 50000]);
xTrain = xTrain/255;

xValid = double(xValid);
tValid = double(tValid);
tmp = zeros(10,10000);
for i = 1:10000
    tmp(tValid(i),i) = 1;
end
tValid = tmp;
xValid = reshape(xValid,[784 10000]);
xValid = xValid/255;

xTest = double(xTest);
tTest = double(tTest);
tmp = zeros(10,10000);
for i = 1:10000
    tmp(tTest(i),i) = 1;
end
tTest = tmp;
xTest = reshape(xTest,[784 10000]);
xTest = xTest/255;


end % end of function
