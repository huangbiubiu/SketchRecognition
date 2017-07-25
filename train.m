clear;

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


%% Extract features

load('norCUFS.mat');

dataset = T(:,:,1:140);
nt = size(dataset,3)/2;
T = zeros(143*236,nt*2);
for i = 1 : 2 * nt
    T(:,i) = featureExtraction(dataset(:,:,i), 'MLBP', 'csdn');
end
save('MLBP.mat','T');

%% Represent prototype

load('MLBP.mat');
X = prototypeRepresentation(T);

%% Discriminant analysis
nt = size(X, 2);

[~, score, ~, ~, ~, mu] = pca(transpose(X));
meancenterX = bsxfun(@minus, X, mean(X)); %uncertain
Y = repmat(1:1:nt/2,2,1);
Y = Y(:);
W = LDA(transpose(X), Y);
% [SW SB] = scattermat(transpose(X),Y);
% ma = SW\SB;
% ma = (ma - min(ma)) ./ (max(ma) - min(ma));
% [~,~,W2] = eig(transpose(ma));
% W = W1 * W2;
save('prototype.mat','W','mu','dataset');