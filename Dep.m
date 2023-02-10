function dep = Dep(data,fuzzy_neighbor,FD,class_num,alpha)

[row,~] = size(data);
PosSet_tmp = [];
for m = 1:row
    fuzzy_neighbor_T = fuzzy_neighbor(m,:);
    for n =1:class_num
        FD_temp = FD(:,n)';
        number = find((fuzzy_neighbor_T - FD_temp) <= 0);
        FN_Inc = length(number) / row;
        if FN_Inc >= alpha
            PosSet_tmp = [PosSet_tmp,m];
        end
    end
end
PosSet = unique(PosSet_tmp);
dep = length(PosSet)/row + 0.000001;

end


