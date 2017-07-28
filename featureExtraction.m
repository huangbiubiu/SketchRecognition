function feature = featureExtraction(I, featureType, filterType, kb, T)
% featureExtraction - Extract SIFT or MLBP features
%
% Syntax: feature = featureExtraction(I, featureType, filterType, kb)
%
% Extract features for each patches and concatenate them.
% Available feature type: 'MLBP' or 'SIFT'
% Available filter type: 'dog', 'csdn' or 'gaussian'
% kb is an optional parameter which is a alpha*n dim integer vector.
    
randomSubspaces = (nargin > 4);

%% Change representation of featureType and filterType

if isnumeric(featureType) %number presentation
    m = featureType;
    [featureType,filterType] = num2string(m);
end

%% Read result directly
    if size(I, 1) == 1 && size(I, 2) == 1
        ftype = [filterType, featureType];
        % load('featureVectors.mat');
        if randomSubspaces
            if mod(m, 2) == 0 %even, SIFT
                featureDim = 128;
            else %odd, MLBP
                featureDim = 236;
            end
            feature = NaN(featureDim*size(kb,1),1);
            for k = 1 : size(kb)
                startIndex = (k - 1) * featureDim + 1;
                TstartIndex = (kb(k) - 1) * featureDim + 1;
                feature(startIndex:startIndex + featureDim - 1) =...
                    T{m}(TstartIndex:TstartIndex + featureDim - 1,I);
                
            end
            
        else
            feature = T{m}(:,I);
        end

        return;
    end

%% Filter    
    switch filterType
    case 'dog'
        [I,~,~] = imageFiltering(I);
    case 'csdn'
        [~,I,~] = imageFiltering(I);
    case 'gaussian'
        [~,~,I] = imageFiltering(I);        
    end

%% Split image to patches
    [patches,nx,ny] = patching(I, 16);
    N = nx * ny;
    
%% Extract features
    
    
    if (randomSubspaces)
        switch featureType
        case 'MLBP'
            feature = zeros(236,size(kb,1));
        case 'SIFT'
            feature = zeros(128,size(kb,1));
        end
        
        for i = 1 : size(kb,1)
            switch featureType
            case 'MLBP'
                feature(:,i) = transpose(mlbp(patches(:,:,kb(i))));
            case 'SIFT'
                [f,~] = sift(patches(:,:,kb(i)));
                num = size(f,1);
                if num == 0
                    f = zeros(1, 128);
                else
                    f = sum(f, 1);
                end
                feature(:,i) = transpose(f);
                % k = k + num;
            end
        end
    else
        switch featureType
        case 'MLBP'
            feature = zeros(236,size(patches,3));
        case 'SIFT'
            feature = zeros(128,size(patches,3));
            % k = 1;
        end

        for i = 1 : size(patches,3)
            switch featureType
            case 'MLBP'
                feature(:,i) = transpose(mlbp(patches(:,:,i)));
            case 'SIFT'
                [f,~] = sift(patches(:,:,i));
                num = size(f,1);
                if num == 0
                    f = zeros(1, 128);
                else
                    f = sum(f, 1);
                end
                feature(:,i) = transpose(f);
                % k = k + num;
            end
        end
    end 

    
    
    % if featureType == 'SIFT'
    %     feature = feature(:,1:k-1);
    % end
    
%% Reshape feature matrix to a vector and normalize
    feature = reshape(feature, [], 1);
    feature = feature ./ sum(feature);
end



%%---------------------Subfunction------------------------%%

function [featureType, filterType] = num2string(num)
    switch(num)
        case 1
            featureType = 'MLBP';
            filterType = 'csdn';
        case 2
            featureType = 'SIFT';
            filterType = 'csdn';
        case 3
            featureType = 'MLBP';
            filterType = 'dog';
        case 4
            featureType = 'SIFT';
            filterType = 'dog';
        case 5
            featureType = 'MLBP';
            filterType = 'gaussian';
        case 6
            featureType = 'SIFT';
            filterType = 'gaussian';
    end
    
end