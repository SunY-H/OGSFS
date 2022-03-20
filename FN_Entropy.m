function FNE = FN_Entropy(data,fuzzy_neighbor)

[row, ~]=size(data);
%dep = Dep(data,fuzzy_neighbor,FD,class_num,alpha);

FNE = 0;
for k = 1:row
    fuzzy_neighbor_temp = fuzzy_neighbor(k,:);
    FN_granual = find(fuzzy_neighbor_temp ~= 0);
    n1=length(FN_granual);
    n2 = 1 / row;
    Condi_en_temp = -n2 * log2(n1 * n2);
    FNE = FNE + Condi_en_temp;
end
     
%FNE = FNE*dep;
  
end