clear;

run('sift_vlfeat/toolbox/vl_setup');

load('norCUFS.mat');
dataset = T;

nt = size(T, 3);
datasize = nt;
patchesLength = 143;
T = cell(6,1);
for m = 1 : 6
    if mod(m, 2) == 0
        % SIFT
        T{m} = zeros(patchesLength*128,datasize);
    else
        T{m} = zeros(patchesLength*236,datasize);
    end
end

for j = 1 : nt
    fprintf('%d / %d\n',j,nt);
    for m = 1 : 6
        T{m}(:,j) = featureExtraction(dataset(:,:,j),m,m);
    end
end

save('featureVectors.mat','T');