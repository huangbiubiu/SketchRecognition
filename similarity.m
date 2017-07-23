function phi = similarity(datai, dataset)
    nt = size(dataset, 2);
    phi = zeros(1,nt);

    for i = 1 : nt
        phi(i) = kernal(datai, dataset(:,i));
    end
end

function similarity = kernal(P, G)
%kernal - Cosine kernel function
%
% Syntax: similarity = kernal(P, G)
%

    similarity = dot(P,G)/(norm(P).*norm(G));    
end