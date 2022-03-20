function FNMI = FN_MI(data,fuzzy_neighbor,FD,class_num)

%dep = Dep(data,fuzzy_neighbor,FD,class_num,alpha);
[row, ~]=size(data);
FNMI = 0;
for k = 1:row
    fuzzy_neighbor_temp1 = fuzzy_neighbor(k,:);
    FN_granual1 = find(fuzzy_neighbor_temp1 ~= 0);
    temp1=length(FN_granual1);
    FN_zeronum = find(fuzzy_neighbor_temp1 == 0);
    for j = 1:class_num
        FD_temp = FD(:,j)';
        FN_granual2 = find(FD_temp ~= 0);
        temp2=length(FN_granual2);
        number = find((fuzzy_neighbor_temp1 - FD_temp) <= 0);
        n2 = length(number) - length(FN_zeronum);
        if n2 > 0 && n2 <= length(FN_granual1)
            n1 = 1 / row;
            MI_en_temp = n1 * log2(n1 * temp1 * temp2 / n2);
            FNMI = FNMI + MI_en_temp;
        end     
    end   
end

end
