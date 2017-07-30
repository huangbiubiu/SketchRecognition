function T = extractAllFeatures(dataset, varargin)
    %parse inputs
    p = inputParser;
    p.CaseSensitive = false;
    addParameter(p,'display',false);
    addParameter(p,'savetodisk',false);
    parse(p,varargin{:})
    
    %initialize the environment
    run('sift_vlfeat/toolbox/vl_setup');
    
    % initialize default parameters
    nt = size(dataset, 3) / 2;
    patchesLength = 143;
    
    %initialize featrue vectors
    T = cell(6,1);
    for m = 1 : 6
        if mod(m, 2) == 0
            % SIFT
            T{m} = zeros(patchesLength*128,2 * nt);
        else
            T{m} = zeros(patchesLength*236,2 * nt);
        end
    end
    
    for j = 1 : 2 * nt
        if p.Results.display
            fprintf('%d / %d\n',j,2 * nt);
        end        
        for m = 1 : 6
            T{m}(:,j) = featureExtraction(dataset(:,:,j),m,m);
        end
    end
    
    if p.Results.savetodisk
        save('featureVectors.mat','T');
    end
end    
