%% Set parameters
gStartIndex = 1; %for gallery
gEndIndex = 10;
beginIndex = 1; %for sketch
endIndex = 10;
gallerySize = gEndIndex - gStartIndex + 1;
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
    for m = 1 : 6
        WLength(bag, m) = size(bagSet(bag).W{m},1)
    end
end
PHILength = transpose(sum(WLength, 1));

%% Load all testing gallery data and extract features

norGallery = norData(:,:,2:2:end);%all training gallery data
testingG = norGallery(:,:, gStartIndex:gEndIndex);%gallery to be matched
% extract gallery features
galleryFeatures = cell(6,gallerySize,B);
for k = gStartIndex : gEndIndex
    for m = 1 : 6
        for bag = 1 : B
            galleryFeatures{m, k, bag} = ...
                featureExtraction(k*2, m, m, bagSet(bag).kb);
        end
    end
end

GPHI = cell(6,gallerySize);
for m = 1 : 6
    for bag = 1 : B
        dataset = bagSet(bag).T{m}(:,2:2:end);
        for k = 1 : gallerySize
            mu = bagSet(bag).mu;
            W = bagSet(bag).W{m};

            phi = similarity(galleryFeatures{m, k, bag}, dataset);
            GPHI{m,k} =[GPHI{m,k},...
                [ones(size(phi,2),1) (phi - transpose(mu))'] * W'];
        end
    end
end

%% Choose a probe image and do recognition
result = zeros(endIndex - beginIndex + 1, 2);

S = zeros(gallerySize, 1);% score with all testing gallery image

for m = 1 : 6
    for g = 1 : gallerySize
        for bag = 1 : B
            kb = bagSet(bag).kb;
            mu = bagSet(bag).mu;

            sketchFeature = featureExtraction(2*index-1, m, m, bagSet(bag).kb);
            phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));
            
            W = bagSet(bag).W{m};
            probe = [probe, ...
                ([ones(size(phiP(m),2),m) (phiP(m) - transpose(mu))'] * W')'];
        end
        S(g) = S(g) + ...
            dot(probe(:,:,m), GPHI{m,g})/...
            ((norm(probe(:,:,m)).*norm(GPHI{m,g})));
    end
end


for index = beginIndex : endIndex
    for m = 1 : 6
        probe = NaN(1, PHILength(m));
        PHIindex = ones(6,1);

        for bag = 1 : B
            kb = bagSet(bag).kb;
            mu = bagSet(bag).mu;
            for m = 1 : 6
                sketchFeature = featureExtraction(2*index-1, m, m, bagSet(bag).kb);
                phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));
                W = bagSet(bag).W{m};
            end
            probe(:,PHIindex(m):PHIindex(m) + WLength(bag,m)) = ...
                    ([ones(size(phiP(m),2),m) (phiP(m) - transpose(mu))'] * W')';
        end
        S(i,:) = S(i,:) + ...
                dot(probe(:,:,m), gallery(:,i))/...
                ((norm(probe(:,:,m)).*norm(gallery(:, i))));
    end

    [~, indexG] = max(S);
    indexG = indexG + gStartIndex - 1;

    
end

%% Plot recognition result
    load('CUFS.mat')
    subplot(1,2,1)
    imshow(sketchset(:,:,index));
    subplot(1,2,2)
    imshow(galleryset(:,:,indexG));
    fprintf('Recognition result: Sketch: %d, Gallery: %d\n',index,indexG);
    result(index - beginIndex + 1,:) = [index, indexG];
