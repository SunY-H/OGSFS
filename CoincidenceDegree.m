function Sum_CD = CoincidenceDegree(X,Y)
%the coincidence degree
[~,P]=size(X);
[partion,~,cj] = unique(Y);
class_num = length(partion);
class = cell(1,class_num);
for i = 1:class_num
    class{i} = find(cj==i);
end
Sum_CD = zeros(1,P);
for l = 1:class_num-1
    for p = l+1:class_num


        CD = zeros(1,P);
        for j = 1:P
            min_1 = 0;
            Max_1 = 0;
            for m = 1:length(class{l})
                if X(class{l}(m),j)<min_1
                    min_1 = X(class{1}(m),j);
                end
                if X(class{l}(m),j)>Max_1
                    Max_1 = X(class{l}(m),j);
                end
            end
            min_2 = 0;
            Max_2 = 0;
            for n = 1:length(class{p})
                if X(class{p}(n),j)<min_2
                    min_2 = X(class{p}(n),j);
                end
                if X(class{p}(n),j)>Max_2
                    Max_2 = X(class{p}(n),j);
                end
            end

            if Max_1<min_2 || Max_2<min_1
                d1 = 0;
                d2 = Max_1-min_1+Max_2-min_2;
            else
                if min_1<min_2
                    min1 = min_2;
                    min2 = min_1;
                else
                    min1 = min_2;
                    min2 = min_2;
                end
                if Max_1>Max_2
                    Max1 = Max_2;
                    Max2 = Max_1;
                else
                    Max1 = Max_1;
                    Max2 = Max_2;
                end

                d1 = Max1-min1;
                d2 = Max2-min2;
            end
            CD(1,j) = (d1+0.00000001)/(d2+0.00000001);

        end
        
            Sum_CD = (Sum_CD + CD)/2;
    end
end