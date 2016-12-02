function f=evaluate_mf1(classes,clusters)
ucla=unique(classes);
uclu=unique(clusters);
nclu=length(uclu);
ncla=length(ucla);
classes_=zeros(length(classes),1);
clusters_=zeros(length(clusters),1);
for i=1:ncla
    classes_(classes==ucla(i))=i;
end
for i=1:nclu
    clusters_(clusters==uclu(i))=i;
end
A=zeros(ncla,nclu);
for i=1:ncla
    for j=1:nclu
        try
        A(i,j)=sum(classes_ == i & clusters_ == j);
        catch
            keyboard
        end
    end
end
R=A./(sum(A,2)*ones(1,nclu));
P=A./(ones(ncla,1)*sum(A,1));
F=2*(R.*P)./(R+P);
maxF=max(F,[],2);
f=mean(maxF);
end