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
% gallerySet = loadData('dataset\testing\photos', false);
% gallerySet = normalize(gallerySet);
% T = extractAllFeatures(gallerySet, 'display', true);
% GPHI = prepareGalleryData(bagSet, gallerySet, T);
% save('GPhi.mat','GPHI','gallerySet','T');
%% Testing
tic;
load('trainingResult.mat');
load('GPhi.mat');
probe = loadData('dataset\testing\sketches', false);
probe = normalize(probe);

result = [];
for k = 1 : size(probe,3)
    result = [result;testing(probe(:,:,k), bagSet, GPHI, T)];
end

result(:,1) = 1:100;
accuracy = sum(result(:,1) == result(:,2));
timespan = toc;
fprintf('Accuracy = %d, time = %d', accuracy, timespan);