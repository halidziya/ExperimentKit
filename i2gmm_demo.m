clear all;
clc;

currentDir=pwd;
addpath([currentDir,'\src']);
mkdir(currentDir,'\experiments');
mkdir(currentDir,'\experiments\simulated');
mkdir(currentDir,'\experiments\simulated\data');
mkdir(currentDir,'\experiments\simulated\results');
mkdir(currentDir,'\experiments\simulated\figures');
addpath([currentDir,'\experiments\simulated\data']);
results_parentdir=[currentDir,'\experiments\simulated\results\'];
addpath(results_parentdir);


%% load image data
load('../data/nips_toy/NIPS14_flower.mat');

%%
for j=1:10
done=0;
run_no=1;
while done==0
[success,message,messageid] = mkdir(results_parentdir,['run',num2str(run_no)]);
if ~isempty(message)
    run_no=run_no+1;
else
    results_dir=[results_parentdir,'run',num2str(run_no),'\'];
    done=1;
end
end


d=size(X,2);
k0=0.05;
ki=0.5;
m=d+2;
s=150/d/log(d);
mu0=mean(X,1);
Psi=(m-d-1)*diag(diag(cov(X)))/10;
alp=1; gam=1;

%% I2GMM

fprintf(1,'Writing files...\n');
i2gmm_createBinaryFiles([ results_dir 'toy' ],X,Psi,mu0,m,k0,ki,alp,gam);
data=[results_dir,'toy.matrix'];
psipath=[results_dir,'toy_psi.matrix'];
meanpath=[results_dir,'toy_mean.matrix'];
params=[results_dir,'toy_params.matrix'];

num_sweeps='520';
burn_in='500';
step='20';
fprintf(1,'I2GMM is running...\n');
cmd = ['i2s.exe ',data,' ',meanpath,' ',psipath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
tic;
system(cmd);
elapsed_time(j)=toc;
fprintf(1,'Reading output');
slabels=readMat([data '.superlabels'])+1;
labels=readMat([data '.labels'])+1;
%[dishes rests likelihood labels]=i2gmm_readOutput(results_dir);
animateHierarchicalData(X,slabels,labels)
c(:,j) = align_labels(slabels');

er=evaluationTable(Y,c(:,j));

scatter(X(:,1),X(:,2),80,c(:,j),'.')
 %fname=[pwd '\experiments\simulated\figures\I2GMM_NIPS14_flower_',num2str(j),'.ps'];
 %print('-depsc','-r300',fname); 
 %fixPSlinestyle(fname)
end