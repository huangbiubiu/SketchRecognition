clear;

load('norCUFS.mat');
dataset = T;

nt = size(T, 3);
datasize = nt;
patchesLength = 143;
Tmc = zeros(patchesLength*236,datasize);
Tsc = zeros(patchesLength*128,datasize);
Tmd = zeros(patchesLength*236,datasize);
Tsd = zeros(patchesLength*128,datasize);
Tmg = zeros(patchesLength*236,datasize);
Tsg = zeros(patchesLength*128,datasize);

for j = 1 : nt
    Tmc(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'csdn');
    Tsc(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'csdn');
    Tmd(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'dog');
    Tsd(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'dog');
    Tmg(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'gaussian');
    Tsg(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'gaussian');
end

save('featureVectors.mat',...
    'Tmc','Tsc',...
    'Tmd','Tsd',...
    'Tmg','Tsg');