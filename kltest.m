d=2
cla
scatter(X(:,1),X(:,2),10);
kli=[];
selected  = 2;
for i=1:max(labels+1)
kli(i)= -0.5 * ( (trace(inv(squeeze(covs(selected,:,:)))*squeeze(covs(i,:,:)))+ ...
    (mus(selected,:)-mus(i,:))*inv(squeeze(covs(selected,:,:)))*(mus(selected,:)-mus(i,:))' - d ...
    + log(det(squeeze(covs(i,:,:)))) - log(det(squeeze(covs(selected,:,:))))));
end
kli=exp(kli);
kli(kli>100)=0.0001;
kli(kli==1)=0.2;
scatter(mus(:,1),mus(:,2),1+8000*kli,'r.')