function [int_relation,relation]= FN_Relation(data,alpha)

[row, col]=size(data);
relation = cell(col-1,1);
for k=1:col-1
    relation{k}=zeros(row);
end
int_relation = ones(row);
for k=1:col-1
   for i=1:row-1
      for j=i+1:row
          if abs(data(i,k)-data(j,k))>alpha
              relation{k}(i,j)=0;
          else
              relation{k}(i,j)=1-abs(data(i,k)-data(j,k));
          end
      end
   end
   relation{k}=relation{k}+relation{k}'+eye(row);
   int_relation = min(int_relation, relation{k});
end

end



    