function [ selectedFeatures,time ] = FNE_OGSFS(X,Y,G,alpha)
%OSGFS_FNRS
[row,P]=size(X);
Data = [X,Y];
%Fuzzy Decision
[int_relation,fuzzy_neighbor_group] = FN_Relation(Data,alpha);
[partion,~,cj] = unique(Y);
class_num = length(partion);
class = cell(1,class_num);
for i = 1:class_num
    class{i} = find(cj==i);
end
FD = zeros(row,class_num);
for i = 1: row
    for j = 1:class_num
        FD(i,j) = (sum(int_relation(i,class{j})))/sum(int_relation(i,:));
    end
end
%Coincidence Degree
CD = CoincidenceDegree(X,Y);
%Dependency Degree
DepC = zeros(1,P);
for k = 1:P
    DepC(1,k) = (1-Dep(X(:,k),fuzzy_neighbor_group{k},FD,class_num,alpha))*CD(k);
end

%Streaming Feature Selection
start=tic;
mode=zeros(1,P);
inter_Selected = find(mode == 1);
for i=1:G:P
    i_end=G+i-1;
    if i_end>P
        i_end=P;
    end
    indexArray = i:i_end;
    X_G=X(:,indexArray);
    %intra group FS
    RED_Selected=FNE_OGSFS_inter(X_G,indexArray,fuzzy_neighbor_group,DepC,FD,class_num);
    G_N=length(RED_Selected);
    %inter group FS
    if isempty(inter_Selected)
        for j=1:G_N
            ind=RED_Selected(1,j);
            index=indexArray(ind);
            mode(1,index)=1;
        end
        inter_Selected = find(mode == 1);
    else
        X_middle = X(:,inter_Selected);
        [~,col_middle]=size(X_middle);
        
        fuzzy_neighbor_middle = ones(row);
        dc1 = 0;
        for k = 1:col_middle
            indk = inter_Selected(k);
            fuzzy_neighbor_middle = min(fuzzy_neighbor_middle,fuzzy_neighbor_group{indk});
            dc1 = dc1 + DepC(indk);
        end
        dc1 = dc1/col_middle;
        
        FNE_Middle = FN_joint_entropy(X_middle,fuzzy_neighbor_middle,dc1,FD,class_num);
        FNMI_Middle = FN_MI(X_middle,fuzzy_neighbor_middle,FD,class_num)/FNE_Middle;
        
        for j=1:G_N
            ind=RED_Selected(1,j);
            index=indexArray(ind);
            mode(1,index)=1;
            
            houxuan_Selected = mode == 1;
            X_houxuan = X(:,houxuan_Selected);
            
            fuzzy_neighbor_houxuan = min(fuzzy_neighbor_middle,fuzzy_neighbor_group{index});
            dc2 = (dc1 + DepC(index)) / 2;
            
            FNE_houxuan = FN_joint_entropy(X_houxuan,fuzzy_neighbor_houxuan,dc2,FD,class_num);
            FNMI_houxuan = FN_MI(X_houxuan,fuzzy_neighbor_houxuan,FD,class_num)/FNE_houxuan;
            
            FNE_J = FN_joint_entropy(X(:,index),fuzzy_neighbor_group{index},DepC(index),FD,class_num);
            FNMI_J = FN_MI(X(:,index),fuzzy_neighbor_group{index},FD,class_num)/FNE_J;
            
            FNID = (FNMI_houxuan - FNMI_Middle - FNMI_J) / (FNMI_Middle+FNMI_houxuan);
            
            if FNID <= 0
                mode(1,index)=0;
            else
                for k = 1:col_middle
                    FNE_K = FN_joint_entropy(X_middle(:,k),fuzzy_neighbor_group{inter_Selected(k)},DepC(inter_Selected(k)),FD,class_num);
                    FNMI_K = FN_MI(X_middle(:,k),fuzzy_neighbor_group{inter_Selected(k)},FD,class_num)/FNE_K;
                    
                    FNE_D = FN_Entropy(Y,FD);
                    
                    FNSU_J = 2*FNMI_J/(FNE_J + FNE_D);
                    FNSU_K = 2*FNMI_K/(FNE_K + FNE_D);
                    S = FNSU_J - FNSU_K;
                    if S <= 0
                        mode(1,index) = 0;
                        break;
                    else
                        mode(1,inter_Selected(k)) = 0;
                    end
                end
            end
        end
        inter_Selected = find(mode == 1);
    end
end
intraSelectedFeatures = find(mode == 1);

X_Inter=X(:,intraSelectedFeatures);
[B,FitInfo]=lasso(X_Inter,Y,'Alpha',1,'CV',5);
minInd=FitInfo.IndexMinMSE;
SF=B(:,minInd);
selectedFeatures=intraSelectedFeatures(SF~=0);
time=toc(start);

