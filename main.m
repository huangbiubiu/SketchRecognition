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
% save('GPhi.mat','GPHI','gallerySet');
%% Testing
load('trainingResult.mat');
load('GPhi.mat');
probe = loadData('dataset\testing\sketches', false);
probe = normalize(probe);

timespan = [];
for k = 1 : 10
    tic;
    result = testing(probe(:,:,1), bagSet, GPHI);
    timesp = toc;
    timespan = [timespan, timesp];
end

