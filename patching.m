function [splitImg,nx,ny] = patching(I, overlap)
    nx = floor(size(I,1)/overlap) - 1;
    ny = floor(size(I,2)/overlap) - 1;
    n = nx * ny;
    splitImg = uint8(zeros(2*overlap, 2*overlap, n));
    
    k = 1;
    for i = 1:overlap:(size(I,1)-overlap)
        for j = 1:overlap:(size(I,2)-overlap)
            splitImg(:,:,k) = cut(I,i,j,2*overlap,2*overlap);

            k = k + 1;
        end
    end
    fprintf('k = %d, size = %d.\n',k,size(splitImg,3));
end

function img = cut(I, i, j, width, height)

    img = I(i:i+width-1,j:j+height-1);
end