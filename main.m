% %% Load training data and extract features
% trainingdataset = loadData('dataset\training\');
% trainingdataset = normalize(trainingdataset);
% 
% traindatafeatures = extractAllFeatures(trainingdataset, 'display', true);
% save('trainingdataset.mat','trainingdataset','traindatafeatures');
% 
% %% Training
% bagSet = train(trainingdataset, traindatafeatures, 'display', true);
% save('trainingResult.mat','bagSet');

% %% Load testing data
% load('trainingResult.mat');
% gallerySet = loadData('PRIP\photos', false);
% gallerySet = normalize(gallerySet);
% T = extractAllFeatures(gallerySet, 'display', true);
% GPHI = prepareGalleryData(bagSet, gallerySet, T);
% save('PRIPGPhi.mat','GPHI','gallerySet','T');
%% Testing
tic;
load('trainingResult.mat');
load('GPhi.mat');
probe = loadData('dataset\testing\sketches', false);
probe = normalize(probe);

rankN = 5;

% result = [];
score = NaN(size(probe, 3), size(probe,3));
for k = 1 : size(probe,3)
    [~, thisscore] = testing(probe(:,:,k), bagSet, GPHI, T);
    score(:, k) = thisscore{1};
%     result = [result;testing(probe(:,:,k), bagSet, GPHI, T)];
end

% result(:,1) = 1:size(probe, 3);
% accuracy = sum(result(:,1) == result(:,2));
% timespan = toc;
% fprintf('Accuracy = %d, time = %d', accuracy, timespan);