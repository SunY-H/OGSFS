function Joint_entropy = FN_joint_entropy(data1,fuzzy_neighbor_granule1,dc,fuzzy_neighbor_granule2,class_num)

[row, ~]=size(data1);
Joint_entropy = 0;
for k = 1:row
    fuzzy_neighbor_temp1 = fuzzy_neighbor_granule1(k,:);
    FN_granual1 = find(fuzzy_neighbor_temp1 ~= 0);
    FN_zeronum1 = find(fuzzy_neighbor_temp1 == 0);
    for j = 1:class_num
        FD_temp = fuzzy_neighbor_granule2(:,j)';
        number = find((fuzzy_neighbor_temp1 - FD_temp) <= 0);
        n2 = length(number) - length(FN_zeronum1) ;
        if n2 > 0 && n2 <= length(FN_granual1)
            n1 = 1 / row;
             Joint_en_temp = -n1 * log2(n1 * n2 * dc);
             Joint_entropy = Joint_entropy + Joint_en_temp;
        end
    end
end
end

