clear all;
clc;
[xTrain, tTrain, xValid, tValid, xTest, tTest] = LoadMNIST(1);
training_set = xTrain;
Nmu = size(xTrain,1);
target = tTrain;

%center the input data around zero for each data set
% training set
% 1) faire la moyenne de chaque input
% 2)  soustraire la moyenne a chaque input
% mean = 0;
% for i = 1:Nmu
%     for j = 1:xTrain(i)
%         mean = mean + xTrain(i);
%     end
% end
% disp(mean);
% return


%Question : La moyenne se fait sur tout les p patterns. Or chaque patern a 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  FIRST NETWORK %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%
%  To init %
%%%%%%%%%%%%
%eta = learnng rate
eta = 0.3;
M1 = 8; % number of neurons on layer one
M2 = 4; 

% repete 30 epoch
T = Nmu;
mini_batch = 10;
max_epoch = 30;

thresholdsM1 = zeros(1,M1);
thresholdsM2 = zeros(1,M2);
threshold = 0;

weights1 = randn(M1,2);
weights2 = randn(M2,M1);
weights3 = randn(1,M2);

for epoch_number = 1:max_epoch
    for mu = 1:Nmu
        disp("mu "+mu);
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
        
        if mod(mu, 10) ==0
            % do smtg
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
