experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('../data/mnist/readData.m')
prefix = char(strcat(folder,'/mnist/i'));
mkdir([prefix,'/plots/']);
X=igmm_normalize(X,20,true);

d=size(X,2);
k0=1;
ki=1;
m=d+3;
mu0=mean(X,1);
Psi=eye(d)*m;
alp=1; gam=1;

fprintf(1,'Writing files...\n');
i2gmm_createBinaryFiles(prefix,X,Psi,mu0,m,k0,ki,alp,gam);

data=char(strcat(prefix,'.matrix'));
pripath=char(strcat(prefix,'_NIWprior.matrix'));
params=char(strcat(prefix,'_params.matrix'));

burn_in='1000';
num_sweeps = '1500';
fprintf(1,'I2GMM is running...\n');
cmd = ['ppcg.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',prefix,' 20'];
tic;
system(cmd);
elapsed = toc;
%[dishes rests likelihood labels]=i2gmm_readOutput('./');
slabels=readMat(char(strcat(prefix,'Labels.matrix')))+1;
%sublabels=readMat(char(strcat(prefix ,'Sublabels.matrix')))+1;
%labels = kmeans(X,length(unique(Y)));
%gmd=gmdistribution.fit(X,26,'Regularize',0.1);
%labels = gmd.cluster(X);
slabels(isnan(slabels))=0;
labels = align_labels(slabels');


f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
macf1 = table2array(f1s(1,1))
micf1 = table2array(f1s(1,2))
clf;
colormap summer;
subplot(2,1,1);
scatter(X(:,1),X(:,2),10,Y);

subplot(2,1,2);
scatter(X(:,1),X(:,2),10,labels);

fprintf(1,'%s\n',cmd);
fprintf(1,'%s\n',cmd);
fprintf(1,'%.3f\n',mean(macf1));
fprintf(1,'%.2f\n',std(macf1));
fprintf(1,'%.2f\n',elapsed);

