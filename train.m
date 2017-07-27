clear;

%% Set parameters
trainRate = 0.7;
B = 30;
alpha = 0.1;
N = 143; %the number of face patches


%% Read in all training data
% loadData('CUFS');

%% Normalize the whole database
% load('CUFS.mat');
% datasize = size(sketchset, 3);
% norSketchset = uint8(zeros(224, 192, datasize));
% norGalleryset = uint8(zeros(224, 192, datasize));
% 
% for i = 1 : datasize
%     gallery = galleryset(:,:,i);
%     sketch = sketchset(:,:,i);
%     
%     norGalleryset(:,:,i) = normalize(gallery,16);
%     norSketchset(:,:,i) = normalize(sketch,16);
%     
%     fprintf('%d % \n', i);
% end
% T = uint8(zeros(224, 192, 2*datasize));
% T(:,:,1:2:end) = norSketchset;
% T(:,:,2:2:end) = norGalleryset;
% save('norCUFS.mat', 'T');
% clear;


bagSet = struct('Wmc',num2cell(1:B),'Wsc',num2cell(1:B),...
    'Wmd',num2cell(1:B),'Wsd',num2cell(1:B),...
    'Wmg',num2cell(1:B),'Wsg',num2cell(1:B),...
    'Tmc',num2cell(1:B),'Tsc',num2cell(1:B),...
    'Tmd',num2cell(1:B),'Tsd',num2cell(1:B),...
    'Tmg',num2cell(1:B),'Tsg',num2cell(1:B),...
    'mu',num2cell(1:B),'kb',num2cell(1:B));
for bags = 1 : B
%Initialize kb
kb = randperm(N, ceil(alpha * N)); %ceil makes alpha * N is a integer
kb = kb';% Let kb be a column vector

bagSet(bags).kb = kb;
%% Extract features

load('norCUFS.mat');

dataSize = size(T, 3) * trainRate;

dataset = T(:,:,1:dataSize);
nt = size(dataset,3)/2;

featureLength = 2 * nt;
patchesLength = size(kb, 1);
Tmc = zeros(patchesLength*236,featureLength);
Tsc = zeros(patchesLength*128,featureLength);
Tmd = zeros(patchesLength*236,featureLength);
Tsd = zeros(patchesLength*128,featureLength);
Tmg = zeros(patchesLength*236,featureLength);
Tsg = zeros(patchesLength*128,featureLength);

for j = 1 : 2 * nt
    Tmc(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'csdn', kb);
    Tsc(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'csdn', kb);
    Tmd(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'dog', kb);
    Tsd(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'dog', kb);
    Tmg(:,j) = featureExtraction(dataset(:,:,j), 'MLBP', 'gaussian', kb);
    Tsg(:,j) = featureExtraction(dataset(:,:,j), 'SIFT', 'gaussian', kb);
end
save('featureVectors.mat',...
    'Tmc','Tsc',...
    'Tmd','Tsd',...
    'Tmg','Tsg');

%% Represent prototype
% clear;
load('featureVectors.mat');
l = size(Tmc, 2);
nt = int32(l/2);
X = NaN(nt, 2*nt,6);

X(:,:,1) = prototypeRepresentation(Tmc(:,:));
X(:,:,2) = prototypeRepresentation(Tsc(:,:));
X(:,:,3) = prototypeRepresentation(Tmd(:,:));
X(:,:,4) = prototypeRepresentation(Tsd(:,:));
X(:,:,5) = prototypeRepresentation(Tmg(:,:));
X(:,:,6) = prototypeRepresentation(Tsg(:,:));
% save('prototype.mat','X');

%% Discriminant analysis

mu = NaN(6, nt);
for j = 1 : 6
    %do PCA
    [coeff, ~, latent, ~, ~, mu(j,:)] = pca(transpose(X(:,:,j)));
    Xvar = sum(latent);
    for element = 1 : size(latent, 1)
        if sum(latent(1:element))/Xvar > 0.99
            break;
        end
    end
    meancenterX = bsxfun(@minus, transpose(X(:,:,j)), mean(transpose(X(:,:,j)))); 
    score = meancenterX * coeff(:,1:element);
    
    %do LDA
    Y = repmat(1:1:nt,2,1);
    Y = Y(:);
    switch j
        case 1
            Wmc = LDA(score, Y);
        case 2
            Wsc = LDA(score, Y);
        case 3
            Wmd = LDA(score, Y);
        case 4
            Wsd = LDA(score, Y);
        case 5
            Wmg = LDA(score, Y);
        case 6
            Wsg = LDA(score, Y);
        
    end
end
bagSet(bags).Wmc = Wmc;
bagSet(bags).Wsc = Wsc;
bagSet(bags).Wmd = Wmd;
bagSet(bags).Wsd = Wsd;
bagSet(bags).Wmg = Wmg;
bagSet(bags).Wsg = Wsg;
bagSet(bags).mu = mu;

% save('prototype.mat','mu',...
%     'Wmc','Wsc',...
%     'Wsg','Wmg',...
%     'Wsd','Wmd');
end
save('prototype.mat','bagSet');