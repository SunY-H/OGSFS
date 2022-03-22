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

    if ~isempty(Selected)
        model_linear = svmtrain(train_label, Selected, '-t 0');
        [~, accuracy_L, ~] = svmpredict(test_label, test_data, model_linear);
        Acc = accuracy_L(1,1);
    else
        Acc=0;
    end
    
    Aver_Accuracy = Aver_Accuracy + Acc;
    
end
Aver_Time = Aver_Time / 10;
Aver_Number = Aver_Number / 10;
Aver_Accuracy = Aver_Accuracy / 10;