function new=normlize_data(Data_2)

    maxold=max(Data_2);
    minold=min(Data_2);

    m=size(Data_2,1);
    maxnew=repmat(maxold,m,1);
    minnew=repmat(minold,m,1);
    new=(Data_2-minnew)./(maxnew-minnew);
    
end