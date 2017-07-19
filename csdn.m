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
function rect = getNeighbor(img, i, j, s1, s2)
    rect = zeros(s1,s2);
    for x = 1 : s1
        for y = 1 : s2
            indexi = mod((x + i - int32(s1/2) - 1), size(img,1)) + 1;
            indexj = mod((y + j - int32(s2/2)) - 1, size(img,2)) + 1;
            rect(i,j) = img(indexi,indexj);
        end
    end
end