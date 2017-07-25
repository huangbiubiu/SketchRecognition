%% Load data
clear;
load('norCUFS.mat');
norData = T;
load('prototype.mat');

load('MLBP.mat');
sketchFeatures = T(:,1:2:end);
galleryFeatures = T(:,2:2:end);
nt = size(T, 2) / 2;

%% Load all testing gallery data and extract features

norGallery = norData(:,:,2:2:end);
testingG = norGallery(:,:, 71:100);
testingGalleryFeatures = zeros(143 * 236, 30);
for i = 1 : size(testingGalleryFeatures, 2)
    testingGalleryFeatures(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'MLBP','csdn');
end

%% 
index = 99;
I = norData(:,:,index);
sketchFeature = featureExtraction(I, 'MLBP', 'csdn');
phiP = similarity(sketchFeature, sketchFeatures);
probe = transpose(W)*(phiP - mu);
