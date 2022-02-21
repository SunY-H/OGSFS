function selectedFeatures = FNE_OGSFS(X_G,indexArray,fuzzy_neighbor_group,DepC,FD,class_num)

[row,p]=size(X_G);

fuzzy_neighbor_AT = ones(row);
dc = 0;
for i = 1:p
    indi = indexArray(i);
    fuzzy_neighbor_AT = min(fuzzy_neighbor_AT,fuzzy_neighbor_group{indi});
    dc = dc + DepC(indi);
end
dc = dc/p;

FNE_AT = FN_joint_entropy(X_G,fuzzy_neighbor_AT,dc,FD,class_num);
FNSU_AT = FN_MI(X_G,fuzzy_neighbor_AT,FD,class_num)/FNE_AT;

intra_Selected = zeros(1,p);
for k = 1 : p
    data_deletek = X_G;
    data_deletek(:,k) = [];
    fuzzy_neighbor_deletek = ones(row);
    dc1 = 0;
    for w = 1:p
        if w~=k
            indw = indexArray(w);
            fuzzy_neighbor_deletek = min(fuzzy_neighbor_deletek,fuzzy_neighbor_group{indw});
            dc1 = dc1 + DepC(indw);
        end
    end
    dc1 = dc1 / (p-1);
    
    FNE_Deletek = FN_joint_entropy(data_deletek,fuzzy_neighbor_deletek,dc1,FD,class_num);
    FNSU_Deletek = FN_MI(data_deletek,fuzzy_neighbor_deletek,FD,class_num)/FNE_Deletek;
    
    FNII = FNSU_AT - FNSU_Deletek;

    if FNII > 0
        intra_Selected(1,k) = 1;
    end
end
selectedFeatures = find(intra_Selected == 1);



    



