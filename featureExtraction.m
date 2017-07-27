function feature = featureExtraction(I, featureType, filterType, kb)
% featureExtraction - Extract SIFT or MLBP features
%
% Syntax: feature = featureExtraction(I, featureType, filterType, kb)
%
% Extract features for each patches and concatenate them.
% Available feature type: 'MLBP' or 'SIFT'
% Available filter type: 'dog', 'csdn' or 'gaussian'
% kb is an optional parameter which is a alpha*n dim integer vector.
    
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
    randomSubspaces = (nargin == 4);
    
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