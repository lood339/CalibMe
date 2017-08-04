% SVM classify
function pre_label = svm_pre(svm_model,test_data)

assert(size(test_data,2)==128);
[pre_label,score] = predict(svm_model,test_data);