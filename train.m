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

% load('norCUFS.mat');
% 
% trainRate = 0.7;
% dataSize = size(T, 3) * trainRate;
% 
% dataset = T(:,:,1:dataSize);
% nt = size(dataset,3)/2;
% 
% Tmc = zeros(143*236,nt*2);
% Tsc = zeros(143*128,nt*2);
% Tmd = zeros(143*236,nt*2);
% Tsd = zeros(143*128,nt*2);
% Tmg = zeros(143*236,nt*2);
% Tsg = zeros(143*128,nt*2);
% 
% for i = 1 : 2 * nt
%     Tmc(:,i) = featureExtraction(dataset(:,:,i), 'MLBP', 'csdn');
%     Tsc(:,i) = featureExtraction(dataset(:,:,i), 'SIFT', 'csdn');
%     Tmd(:,i) = featureExtraction(dataset(:,:,i), 'MLBP', 'dog');
%     Tsd(:,i) = featureExtraction(dataset(:,:,i), 'SIFT', 'dog');
%     Tmg(:,i) = featureExtraction(dataset(:,:,i), 'MLBP', 'gaussian');
%     Tsg(:,i) = featureExtraction(dataset(:,:,i), 'SIFT', 'gaussian');
% end
% save('featureVectors.mat',...
%     'Tmc','Tsc',...
%     'Tmd','Tsd',...
%     'Tmg','Tsg');

%% Represent prototype
clear;
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
save('prototype.mat','X');
%% Discriminant analysis
W = NaN(nt, nt+1, 6);
mu = NaN(nt, 6);
for i = 1 : 6
    [~, score, ~, ~, ~, mu(:, i)] = pca(transpose(X(:,:,i)));
%     meancenterX = bsxfun(@minus, X, mean(X)); %uncertain
    Y = repmat(1:1:nt/2,2,1);
    Y = Y(:);
    switch i
        case 1
            Wmc = LDA(transpose(X(:,:,i)), Y);
        case 2
            Wsc = LDA(transpose(X(:,:,i)), Y);
        case 3
            Wmd = LDA(transpose(X(:,:,i)), Y);
        case 4
            Wsd = LDA(transpose(X(:,:,i)), Y);
        case 5
            Wmg = LDA(transpose(X(:,:,i)), Y);
        case 6
            Wsg = LDA(transpose(X(:,:,i)), Y);
        
    end
end
save('prototype.mat','mu',...
    'Wmc','Wsc',...
    'Wsg','Wmg',...
    'Wsd','Wmd');