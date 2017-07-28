function [descriptors, locs] = sift(image)
%sift - Extract SIFT features and locations
%
% Syntax: [descriptors, locs] = sift(img)
%
% This function is a wapper of SIFT implementation of David Lowe
%     cd sift_zheng
%         [~, descriptors, locs] = sift(image);
%     cd ..
    frames = size(image)/2;
    frames = [frames 1 0];
    [locs, descriptors] = vl_sift(im2single(image), 'frames', frames');
end
