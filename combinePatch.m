function combinedImg = combinePatch(patches, nx, ny)
    samplePatch = patches(:,:,1);
    patchSize = size(samplePatch,1);

    combinedImg = uint8(zeros(nx*patchSize,ny*patchSize));

    k = 1;
    for i = 1:patchSize:nx*patchSize
        for j = 1:patchSize:ny*patchSize
            combinedImg(i: i+patchSize-1 , ...
                j: j+patchSize-1) ...
                = patches(:,:,k);
            k = k + 1;
        end
    end
    
end