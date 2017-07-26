%% Load data
clear;
load('norCUFS.mat');
norData = T;
load('prototype.mat');

load('featureVectors.mat');
sketchFeaturesMc = Tmc(:,1:2:end,:);
galleryFeaturesMc = Tmc(:,2:2:end,:);
sketchFeaturesSc = Tsc(:,1:2:end,:);
galleryFeaturesSc = Tsc(:,2:2:end,:);
sketchFeaturesMd = Tmd(:,1:2:end,:);
galleryFeaturesMd = Tmd(:,2:2:end,:);
sketchFeaturesSd = Tsd(:,1:2:end,:);
galleryFeaturesSd = Tsd(:,2:2:end,:);
sketchFeaturesMg = Tmg(:,1:2:end,:);
galleryFeaturesMg = Tmg(:,2:2:end,:);
sketchFeaturesSg = Tsg(:,1:2:end,:);
galleryFeaturesSg = Tsg(:,2:2:end,:);
nt = size(Tmc, 2) / 2;

%% Load all testing gallery data and extract features
gStartIndex = 1;
gEndIndex = 20;


norGallery = norData(:,:,2:2:end);
testingG = norGallery(:,:, gStartIndex:gEndIndex);
testingGalleryFeaturesMc = ...
    zeros(143 * 236, gEndIndex - gStartIndex + 1);%MLBP with CSDN
testingGalleryFeaturesSc = ...
    zeros(143 * 128, gEndIndex - gStartIndex + 1);
testingGalleryFeaturesMd = ...
    zeros(143 * 236, gEndIndex - gStartIndex + 1);
testingGalleryFeaturesSd = ...
    zeros(143 * 128, gEndIndex - gStartIndex + 1);
testingGalleryFeaturesMg = ...
    zeros(143 * 236, gEndIndex - gStartIndex + 1);
testingGalleryFeaturesSg = ...
    zeros(143 * 128, gEndIndex - gStartIndex + 1);
for i = 1 : size(testingGalleryFeatures, 2)
    testingGalleryFeaturesMc(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'MLBP','csdn');
    testingGalleryFeaturesSc(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'SIFT','csdn');
    testingGalleryFeaturesMd(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'MLBP','dog');
    testingGalleryFeaturesSd(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'SIFT','dog');
    testingGalleryFeaturesMg(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'MLBP','gaussian');
    testingGalleryFeaturesSg(:,i) = ...
        featureExtraction(testingG(:,:,i),...
        'SIFT','gaussian');
end
gallery = zeros(nt, size(testingG, 3), 6);%phi of all gallery
for i = 1 : size(gallery, 2)
    phiG = similarity(testingGalleryFeaturesMc(:, i),...
        galleryFeatures);
    gallery(:,i,1) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,1)';
    phiG = similarity(testingGalleryFeaturesSc(:, i),...
        galleryFeatures);
    gallery(:,i,2) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,2)';
    phiG = similarity(testingGalleryFeaturesMd(:, i),...
        galleryFeatures);
    gallery(:,i,3) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,3)';
    phiG = similarity(testingGalleryFeaturesSd(:, i),...
        galleryFeatures);
    gallery(:,i,4) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,4)';
    phiG = similarity(testingGalleryFeaturesMg(:, i),...
        galleryFeatures);
    gallery(:,i,5) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,5)';
    phiG = similarity(testingGalleryFeaturesSg(:, i),...
        galleryFeatures);
    gallery(:,i,6) = ...
        [ones(size(phiG,2),1) (phiG - transpose(mu))'] * W(:,:,6)';
end

%% Choose a probe image
beginIndex = 1;
endIndex = 10
result = zeros(endIndex - beginIndex + 1, 2);
for index = beginIndex : endIndex
%     index = randi([71,100]); %Can be a random image
    I = norData(:, :, index);
    sketchFeatureMc = featureExtraction(I, 'MLBP', 'csdn');
    sketchFeatureSc = featureExtraction(I, 'SIFT', 'csdn');
    sketchFeatureMd = featureExtraction(I, 'MLBP', 'dog');
    sketchFeatureSd = featureExtraction(I, 'SIFT', 'dog');
    sketchFeatureMg = featureExtraction(I, 'MLBP', 'gaussian');
    sketchFeatureSg = featureExtraction(I, 'SIFT', 'gaussian');
    phiP = NaN(6,1);
    phiP(1) = similarity(sketchFeatureMc, sketchFeaturesMc);
    phiP(2) = similarity(sketchFeatureSc, sketchFeaturesSc);
    phiP(3) = similarity(sketchFeatureMd, sketchFeaturesMd);
    phiP(4) = similarity(sketchFeatureSd, sketchFeaturesSd);
    phiP(5) = similarity(sketchFeatureMg, sketchFeaturesMg);
    phiP(6) = similarity(sketchFeatureSg, sketchFeaturesSg);
    % probe = transpose(W)*(phiP - transpose(mu));

    probe = NaN(nt, size(testingG, 3), 6);
    for m = 1 : 6
        probe(:,:,m) = ...
            ([ones(size(phiP,2),m) (phiP - transpose(mu))'] * W')';
    end
    

    %% Recognition
    S = zeros(size(gallery,2), 1);% score with all testing gallery image
    for i = 1 : size(gallery, 2) % calculate all S function
        S(i,1) = 0;
        for m = 1 : 6
            S(i,:) = S(i,:) + ...
                dot(probe(:,:,m), gallery(:,i))/...
                ((norm(probe(:,:,m)).*norm(gallery(:, i))));
        end
    end

    [~, indexG] = max(S);
    indexG = indexG + gStartIndex - 1;

    %% Plot recognition result
    load('CUFS.mat')
    subplot(1,2,1)
    imshow(sketchset(:,:,index));
    subplot(1,2,2)
    imshow(galleryset(:,:,indexG));
    fprintf('Recognition result: Sketch: %d, Gallery: %d\n',index,indexG);
    result(index - beginIndex + 1,:) = [index, indexG];
end