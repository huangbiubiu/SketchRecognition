function result = testing(dataset, bagSet, GPHI)
    % Set parameters
    gallerySize = size(GPHI, 2);
    datasize = size(dataset, 3);
    B = 30;
    alpha = 0.1;
    
    WLength = zeros(B, 6);
    for bag = 1 : B
        for m = 1 : 6
            WLength(bag, m) = size(bagSet(bag).W{m},2);
        end
    end
    PHILength = transpose(sum(WLength, 1));
    
    % pre-extract all sketch features
    testingPreExtractedFeature = ...
        extractAllFeatures(dataset, 'display', true);
    
    % Recognition
    result = zeros(datasize, 2);
    for index = 1 : datasize       
        %initialization
        fprintf('Recognition: %d / %d\n',index,datasize);
        S = zeros(gallerySize, 6);% score with all testing gallery image
        for g = 1 : gallerySize
            for m = 1:6
                    probe = [];
                for bag = 1 : B
                    kb = bagSet(bag).kb;
                    mu = bagSet(bag).mu(m,:);
                    sketchFeature = featureExtraction(index, m, m, bagSet(bag).kb,testingPreExtractedFeature);
                    phiP = similarity(sketchFeature, bagSet(bag).T{m}(:,1:2:end));

                    W = bagSet(bag).W{m};
                    probe = [probe, phiP' * W];
                    

                end
                S(g,m) = S(g,m) + ...
                    dot(probe, GPHI{m,g})/...
                    (norm(probe).*norm(GPHI{m,g}));
        %         fprintf('%d. g = %d, m = %d.\n',(norm(probe).*norm(GPHI{m,g})),g,m);
            end
        end

        % normalize S
        for m = 1 : 6
            S(:,m) = (S(:,m) - min(S(:,m))) / (max(S(:,m)) - min(S(:,m)));
        end
        S = S(:,[1:3 5:6]);%abandon the combination of SIFT and DoG
        S = sum(S, 2);

        [~, indexG] = max(S);
        
        result(index,:) = [index, indexG];
        fprintf('Result: %d %d',index, indexG);
    end
    
end