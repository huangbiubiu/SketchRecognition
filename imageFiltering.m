function [dogimg, csdnimg, gaussian] = imageFiltering(img)
    dogimg = dog(img, 2, 4);
    csdnimg = csdn(img, 16);
    gaussian = imgaussfilt(img, 2);
end

function dogimg = dog(img, sigma1, sigma2)
    GaussKernel = 3;
    
    GaussFilt1 = fspecial('Gaussian', GaussKernel, sigma1);
    GaussFilt2 = fspecial('Gaussian', GaussKernel, sigma2);
    
    DiffGauss = GaussFilt2 - GaussFilt1;
    dogimg(:,:) = conv2(double(img), DiffGauss, 'same');

end

function img = csdn(oriimg, s)
    img = imfilter(oriimg,fspecial('average',[s s]));

    % for i = 1 : size(oriimg, 1)
    %     for j = 1 : size(oriimg, 2)
    %         r = getNeighbor(oriimg,i,j,s,s);
    %         oriimg(i,j) = oriimg(i,j)/(sum(sum(r))/(s*s));
    %         fprintf('position (%d,%d)\n',i,j);
    %     end
    % end
end
% function rect = getNeighbor(img, i, j, s1, s2)
%     rect = zeros(s1,s2);
%     for x = 1 : s1
%         for y = 1 : s2
%             indexi = mod((x + i - int32(s1/2) - 1), size(img,1)) + 1;
%             indexj = mod((y + j - int32(s2/2)) - 1, size(img,2)) + 1;
%             rect(i,j) = img(indexi,indexj);
%         end
%     end
% end