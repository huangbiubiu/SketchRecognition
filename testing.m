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
gallery = zeros(70, size(testingG, 3));
for i = 1 : size(gallery, 2)
    phiG = similarity(testingGalleryFeatures(:, i),...
        galleryFeatures);
    gallery(:,i) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W';
end

%% Choose a probe image
result = zeros(30, 2);
for index = 71 : 100
%     index = randi([71,100]); %Can be a random image
    I = norData(:, :, index);
    sketchFeature = featureExtraction(I, 'MLBP', 'csdn');
    phiP = similarity(sketchFeature, sketchFeatures);
    % probe = transpose(W)*(phiP - transpose(mu));
    probe = [ones(size(phiP,2),1) (phiP - transpose(mu))'] * W';
    probe = probe';

    %% Recognition
    S = zeros(size(gallery,2), 1);% score with all testing gallery image
    for i = 1 : size(gallery, 2) % calculate all S function
        S(i,:) = dot(probe, gallery(:,i))/((norm(probe).*norm(gallery(:, i))));
    end

    [~, indexG] = max(S);
    indexG = indexG + 70;

    %% Plot recognition result
    load('CUFS.mat')
    subplot(1,2,1)
    imshow(sketchset(:,:,index));
    subplot(1,2,2)
    imshow(galleryset(:,:,indexG));
    fprintf('Recognition result: Sketch: %d, Gallery: %d\n',index,indexG);
    result(index - 70,:) = [index, indexG];
end