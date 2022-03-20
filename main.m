function [Aver_Accuracy,Aver_Number,Aver_Time]=main(Data,G,alpha)

[~,b] = size(Data);
xtrain = Data(:,1:b-1);
ytrain = Data(:,b);

data=double(xtrain);
label=double(ytrain);

[M,N]=size(data);
indices=crossvalind('Kfold',data(1:M,N),10);
Aver_Time = 0;
Aver_Number = 0;
Aver_Accuracy = 0;
for k=1:10
    test = (indices == k);
    train = ~test;
    train_data=data(train,:);
    train_label=label(train,:);

    Input_data = normlize_data(train_data);

    [ selectedFeatures,time] = FNE_OGSFS(Input_data,train_label,G,alpha);

    Aver_Time = Aver_Time + time;
    Aver_Number = Aver_Number + length(selectedFeatures);
    Selected = Input_data(:,selectedFeatures);

    test_data=data(test,selectedFeatures);
    test_data=normlize_data(test_data);
    test_label=label(test,:);

%     if ~isempty(Selected)
%         %Train the classifier
%         nb = fitcknn(Selected,train_label,'NumNeighbors',3);
%         %Test the classifier
%         predicted_label = predict(nb,test_data);
%         Acc = length(find(predicted_label==test_label))/length(test_label)*100;
%     else
%         Acc=0;
%     end

%     if ~isempty(Selected)
%         %Train the classifier
%         nb = fitcnb(Selected,train_label);
%         %Test the classifier
%         predicted_label = predict(nb,test_data);
%         Acc = length(find(predicted_label==test_label))/length(test_label)*100;
%     else
%         Acc=0;
%     end

    if ~isempty(Selected)
        model_linear = svmtrain(train_label, Selected, '-t 0');
        [~, accuracy_L, ~] = svmpredict(test_label, test_data, model_linear);
        Acc = accuracy_L(1,1);
    else
        Acc=0;
    end

%     if ~isempty(Selected)
%         
%         tree=fitctree(Selected,train_label);
%         %view(tree,'Mode','graph');%生成树图
%         %rules_num=(tree.IsBranchNode==0);
%         %rules_num=sum(rules_num);%求取规则数量
%         Cart_result=predict(tree,test_data);%使用测试样本进行验证
%         Cart_result=(Cart_result==test_label);
%         Cart_length=size(Cart_result,1);%统计准确率
%         Cart_rate=(sum(Cart_result))/Cart_length*100;
%         %disp(['规则数：' num2str(rules_num)]);
%         %disp(['测试样本识别准确率：' num2str(Cart_rate)]);
%         
%         Acc = Cart_rate;
%     else
%         Acc=0;
%     end
    
    Aver_Accuracy = Aver_Accuracy + Acc;
    
end
Aver_Time = Aver_Time / 5;
Aver_Number = Aver_Number / 5;
Aver_Accuracy = Aver_Accuracy / 5;