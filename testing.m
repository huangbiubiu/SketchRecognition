clear;
%% Set parameters
gStartIndex = 1; %for gallery
gEndIndex = 10;
beginIndex = 1; %for sketch
endIndex = 10;
gallerySize = gEndIndex - gStartIndex + 1;
B = 30;
alpha = 0.1;
%% Load data
load('norCUFS.mat');
norData = T;
datasize = size(T, 3);
load('prototype.mat');
% PHILength = zeros(6,1);
WLength = zeros(B, 6);
for bag = 1 : B
    for m = 1 : 6
        WLength(bag, m) = size(bagSet(bag).W{m},2);
    end
end
PHILength = transpose(sum(WLength, 1));
load('featureVectors.mat');
%% Load all testing gallery data and extract features

norGallery = norData(:,:,2:2:end);%all training gallery data
testingG = norGallery(:,:, gStartIndex:gEndIndex);%gallery to be matched
% extract gallery features
galleryFeatures = cell(6,gallerySize,B);
for k = gStartIndex : gEndIndex
    for m = 1 : 6
        for bag = 1 : B
            galleryFeatures{m, k, bag} = ...
                featureExtraction(k*2, m, m, bagSet(bag).kb, T);
        end
    end
end

GPHI = cell(6,gallerySize);
for m = 1 : 6
    for k = 1 : gallerySize
        for bag = 1 : B
            dataset = bagSet(bag).T{m}(:,2:2:end);
            mu = bagSet(bag).mu(m,:);
            W = bagSet(bag).W{m};
            phi = similarity(galleryFeatures{m, k, bag}, dataset);
%             GPHI{m,k} =[GPHI{m,k},...
%                 [ones(size(phi,2),1) (phi - transpose(mu))'] * W'];
            GPHI{m, k} = [GPHI{m, k}, phi' * W];
        end
    end
end

%% Choose a probe image and do recognition
index = 5; %index of probe to be matched

%initialization
result = zeros(endIndex - beginIndex + 1, 2);
S = zeros(gallerySize, 6);% score with all testing gallery image

for g = 1 : gallerySize
    for m = 1:6
            probe = [];
        for bag = 1 : B
            kb = bagSet(bag).kb;
            mu = bagSet(bag).mu(m,:);

            sketchFeature = featureExtraction(2*index-1, m, m, bagSet(bag).kb, T);
            phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));

            W = bagSet(bag).W{m};
    %             probe = [probe, ...
    %                 ([ones(size(phiP(m),2),m) (phiP(m) - transpose(mu))'] * W')'];
            probe = [probe, phiP' * W];

        end
        S(g,m) = S(g,m) + ...
            dot(probe, GPHI{m,g})/...
            (norm(probe).*norm(GPHI{m,g}));
        
%         fprintf('%d. g = %d, m = %d.\n',(norm(probe).*norm(GPHI{m,g})),g,m);
    end
end

% normalize S
for m = 1 : 6
    S(:,m) = (S(:,m) - min(S(:,m))) / (max(S(:,m)) - min(S(:,m)));
end
S = S(:,[1:3 5:6]);
S = sum(S, 2);

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
