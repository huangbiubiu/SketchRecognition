function similarity = kernal(P, G)
%kernal - Cosine kernel function
%
% Syntax: similarity = kernal(P, G)
%
    similarity = dot(P,G)/(norm(P).*norm(G));    
end