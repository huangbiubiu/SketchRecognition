%% Set parameters
testingRate = 0.3;
gStartIndex = 1;
gEndIndex = 20;

B = 30;
alpha = 0.1;
%% Load data
clear;
load('norCUFS.mat');
norData = T;
datasize = size(T, 3);
load('prototype.mat');
PHILength = zeros(6,1);
WLength = zeros(B, 6);
for bag = 1 : B
    WLength(bag, 1) = size(bagSet(bag).Wmc,1);
    WLength(bag, 2) = size(bagSet(bag).Wsc,1);
    WLength(bag, 3) = size(bagSet(bag).Wmd,1);
    WLength(bag, 4) = size(bagSet(bag).Wsd,1);
    WLength(bag, 5) = size(bagSet(bag).Wmg,1);
    WLength(bag, 6) = size(bagSet(bag).Wsg,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wmc,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wsc,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wmd,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wsd,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wmg,1);
    % PHILength(1) = PHILength + size(bagSet(bag).Wsg,1);
end
PHILength = sum(WLength, 1);
PHILength = transpose(PHILength);

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

norGallery = norData(:,:,2:2:datasize * (1-testingRate));%training gallery data
testingG = norGallery(:,:, gStartIndex:gEndIndex);%gallery to be matched
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
    probe = NaN(nt, PHILength, 6);
    PHIindex = ones(6,1);
    for bags = 1 : B
        kb = bagSet(bags).kb;
        sketchFeatureMc = featureExtraction(index, 'MLBP', 'csdn', kb);
        sketchFeatureSc = featureExtraction(index, 'SIFT', 'csdn', kb);
        sketchFeatureMd = featureExtraction(index, 'MLBP', 'dog', kb);
        sketchFeatureSd = featureExtraction(index, 'SIFT', 'dog', kb);
        sketchFeatureMg = featureExtraction(index, 'MLBP', 'gaussian', kb);
        sketchFeatureSg = featureExtraction(index, 'SIFT', 'gaussian', kb);

        phiP = NaN(6,1);
        phiP(1) = similarity(sketchFeatureMc, bagSet(bags).Tmc(:,1:2:end));
        phiP(2) = similarity(sketchFeatureSc, bagSet(bags).Tsc(:,1:2:end));
        phiP(3) = similarity(sketchFeatureMd, bagSet(bags).Tmd(:,1:2:end));
        phiP(4) = similarity(sketchFeatureSd, bagSet(bags).Tsd(:,1:2:end));
        phiP(5) = similarity(sketchFeatureMg, bagSet(bags).Tmg(:,1:2:end));
        phiP(6) = similarity(sketchFeatureSg, bagSet(bags).Tsg(:,1:2:end));

        probe = NaN(nt, size(testingG, 3), 6);%size(testingG, 3)?
        mu = bagSet(bags).mu;
        % for m = 1 : 6
        %     probe(:,k:k + ,m) = ...
        %         ([ones(size(phiP,2),m) (phiP - transpose(mu))'] * W')';
        % end
        probe(:,PHIindex(1):PHIindex(1) + size(bagSet(bag).Wmc),1) = ...
            ([ones(size(phiP,2),1) (phiP(1) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wmc')';
        probe(:,PHIindex(2):PHIindex(2) + size(bagSet(bag).Wsc),1) = ...
            ([ones(size(phiP,2),2) (phiP(2) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wsc')';
        probe(:,PHIindex(3):PHIindex(3) + size(bagSet(bag).Wmd),1) = ...
            ([ones(size(phiP,2),3) (phiP(3) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wmd')';
        probe(:,PHIindex(4):PHIindex(4) + size(bagSet(bag).Wsd),1) = ...
            ([ones(size(phiP,2),4) (phiP(4) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wsd')';
        probe(:,PHIindex(5):PHIindex(5) + size(bagSet(bag).Wmg),1) = ...
            ([ones(size(phiP,2),5) (phiP(5) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wmg')';
        probe(:,PHIindex(6):PHIindex(6) + size(bagSet(bag).Wsg),1) = ...
            ([ones(size(phiP,2),6) (phiP(6) - transpose(bagSet(bag).mu))'] * bagSet(bag).Wsg')';
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