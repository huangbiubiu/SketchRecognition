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


% bagSet = struct('W',num2cell(1:B),'T',num2cell(1:B),...
%     'mu',num2cell(1:B),'kb',num2cell(1:B));
bagSet = struct('W',[],'T',[],...
    'mu',[],'kb',[]);
% bagSet = struct;
for bag = 1 : B
    %% Progress
        fprintf('Bag %d / %d.\n', bag, B);
    %% Load data
    load('norCUFS.mat');

    dataSize = size(T, 3) * trainRate;

    dataset = T(:,:,1:dataSize);
    nt = size(dataset,3)/2;
        
    %% Initialization
    
    %Initilize kb
    kb = randperm(N, ceil(alpha * N)); %ceil makes alpha * N is a integer
    kb = kb';% Let kb be a column vector

    bagSet(bag).kb = kb;
    
    %Initilize T
    bagSet(bag).T = cell(6,1);
    for m = 1 : 6
        patchNum = size(kb,1);
        if mod(m, 2) == 0 %SIFT
            fL = 128;
        else
            fL = 236;
        end
        bagSet(bag).T{m} = NaN(fL*patchNum,2*nt);
    end
    
    %% Extract features

    

    load('featureVectors.mat');
    preExtractedFeature = T;
    for j = 1 : 2 * nt
        for m = 1 : 6
            bagSet(bag).T{m}(:,j) = featureExtraction(j,m,m,kb,preExtractedFeature);
        end
    end

    %% Represent prototype
    X = NaN(nt, 2*nt,6);

    for m = 1 : 6
        X(:,:,m) = prototypeRepresentation(bagSet(bag).T{m});
    end

    %% Discriminant analysis

    mu = NaN(6, nt);
    W = cell(6,1);
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
        W{j} = LDA(score, Y);
    end
    bagSet(bag).W = W;
    bagSet(bag).mu = mu;

    % save('prototype.mat','mu',...
    %     'Wmc','Wsc',...
    %     'Wsg','Wmg',...
    %     'Wsd','Wmd');
end
save('prototype.mat','bagSet');