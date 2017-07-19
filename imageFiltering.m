function [dogimg, csdnimg, gaussian] = imageFiltering(img)
    dogimg = dog(img, 2, 4);
    csdnimg = csdn(img, 16);
    gaussian = imgaussfilt(img, 2);
end