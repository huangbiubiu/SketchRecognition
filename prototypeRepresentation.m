function X = prototypeRepresentation(T)
%prototypeRepresentation - A function to get the prototype representation X for training set T
%
% Syntax: X = prototypeRepresentation(T)
%
% Refer to (9) in the paper.
% T should be a height*width*nt matrix, where p is the size
% of the image.
% The argument P and G is actually f(P) and f(G) in the paper.
% i.e. |P_1 |
%      |G_1 |
%      |P_2 |
%      |G_2 |
%      ...
%      |P_nt|
%      |G_nt|
    l = size(T, 3);
    nt = int32(l/2);

    Pset = T(1:2:end);
    Gset = T(2:2:end);

    X = zeros(nt, 2*nt);
    for i = 1 : nt
        if mod(i, 2) == 1 %P
            X(:,i) = similarity(T(:,:,i), Pset);
        else %G
            X(:,i) = similarity(T(:,:,i), Gset);
        end
    end
end