%run('C:\Users\hzyereba\Desktop\data\letter\readData.m')
%X=igmm_normalize(X,20,true);
load('C:\Users\hzyereba\Desktop\data\toy\ToyData_25Samples_I2GMM_journal')
d=size(X,2);
k0=0.05;
ki=0.5;
m=d+2;
mu0=mean(X,1);
Psi=2*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
alp=1; gam=1;

i2gmm_createBinaryFiles('experiments\toy',X,Psi,mu0,m,k0,ki,alp,gam);
data=char(strcat('experiments\toy','.matrix'));
psipath=char(strcat('experiments\toy','_psi.matrix'));
meanpath=char(strcat('experiments\toy','_mean.matrix'));
params=char(strcat('experiments\toy','_params.matrix'));

%writeMat(data,X,'double');

num_sweeps = '2000';
burn_in='1600';
step='10';
fprintf(1,'I2GMM is running...\n');
cmd = ['i2s.exe ',data,' ',meanpath,' ',psipath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
tic
system(cmd);
toc
labels=readMat('experiments\toy.matrix.labels')+1;
slabels=readMat('experiments\toy.matrix.superlabels')+1;
animateHierarchicalData(X,slabels,labels)
alabels = align_labels(slabels');
evaluationTable(Y(Y~=0),alabels(Y~=0))
%animateHierarchicalData(X,labels,labels)

