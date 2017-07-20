function [descriptors, locs] = sift(image)
%sift - Extract SIFT features and locations
%
% Syntax: [descriptors, locs] = sift(img)
%
% This function is a wapper of SIFT implementation of David Lowe
    cd sift
        [~, descriptors, locs] = sift(image);
    cd ..
end
