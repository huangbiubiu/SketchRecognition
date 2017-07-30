function bagSet = train(dataset, preExtractedFeature, varargin)
% train - train the database for sketch face matching
%
% Syntax: bagset = train(normalizedDatabase)
%
% The input database should be normalized!

%% Parse input arguments
    p = inputParser;
    p.CaseSensitive = false;
    addParameter(p,'display',false);
    addParameter(p,'savetodisk',false);
    parse(p,varargin{:});
    display = p.Results.display;
    savetodisk = p.Results.savetodisk;


%% Set parameters
    trainRate = 1;
    B = 30;
    alpha = 0.1;
    N = 143; %the number of face patches
    nt = size(dataset, 3) / 2;
    
%% Train each bag using random sampling
    bagSet = struct('W',[],'T',[],...
        'mu',[],'kb',[]);
    for bag = 1 : B
        %% Progress
            if display
                fprintf('Bag %d / %d.\n', bag, B);
            end

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
        
        for k = 1 : 2 * nt
            for m = 1 : 6
                bagSet(bag).T{m}(:,k) = ...
                    featureExtraction(k,m,m,kb,preExtractedFeature);
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
        for k = 1 : 6
            %do PCA
            [coeff, ~, latent, ~, ~, mu(k,:)] = pca(transpose(X(:,:,k)));
            Xvar = sum(latent);
            for element = 1 : size(latent, 1)
                if sum(latent(1:element))/Xvar > 0.99
                    break;
                end
            end
            meancenterX = bsxfun(@minus, transpose(X(:,:,k)), mean(transpose(X(:,:,k)))); 
            score = meancenterX * coeff(:,1:element);

            %do LDA
            Y = repmat(1:1:nt,2,1);
            Y = Y(:);
            W{k} = LDA(score, Y);
        end
        bagSet(bag).W = W;
        bagSet(bag).mu = mu;
    end
    if savetodisk
        save('trainingResult.mat','bagSet');
    end
end

