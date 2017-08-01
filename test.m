load('temp.mat');
acc = zeros(100,1);
% for rank = 1 : 40
%     for k = 1 : 40
%         [~,index] = sort(score(:, k),'descend');
%         index = index(1:rank);
%         if find(index == k)
%             acc(rank) = acc(rank) + 1;
%         end 
%     end
% end
[~, index] = sort(score, 1, 'descend');
for rank = 1:100
    thisscore = index(1:rank,:);
    for k = 1 : 100
        if find(thisscore(:,k) == k)
            acc(rank) = acc(rank) + 1;
        end
    end
end
acc = acc ./ 100;