% compute false negative data
function false_neg = fn(ground_truth,pre_label,test_data)
% ground truth:labels
% pre_label:svm classified labels
% test data[]:image idx,feature point location(x,y)
assert(size(test_data,2) == 3);
false_neg = [];
for i = 1:size(ground_truth)
    if ground_truth(i,1) == 1 && pre_label(i,1) == -1
        false_neg(end+1,:) = test_data(i,:);
    end
end
