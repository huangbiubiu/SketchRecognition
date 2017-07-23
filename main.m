clear;

%% Read in all training data
% loadData('CUFS');

%% Normalize
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

%% Load data
load('norCUFS.mat');

%% Extract features
% nt = size(T,3)/2;
% dataset = T;
% T = zeros(143*236,nt*2);
% for i = 1 : 2 * nt
%     T(:,i) = featureExtraction(dataset(:,:,i), 'MLBP', 'csdn');
% end
% save('MLBP.mat','T');
%% Represent prototype
load('MLBP.mat');
X = prototypeRepresentation(T);

%% Discriminant analysis
nt = size(X, 2);
[W1, score, ~, ~, ~, mu] = pca(transpose(X));
meancenterX = bsxfun(@minus, X, mean(X)); %uncertain
Y = repmat(1:1:nt/2,2,1);
Y = Y(:);
% [SW SB] = scattermat(transpose(meancenterX)*W1,Y);
[SW SB] = scattermat(score,Y);
[~,~,W2] = eig(transpose(inv(SW)*SB));
W = W1 * W2;
