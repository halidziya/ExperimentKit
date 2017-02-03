clear all;
clc;
currentDir=pwd;
addpath([currentDir,'\src']);
addpath([currentDir,'\experiments\stem\data']);
results_parentdir=[currentDir,'\experiments\stem\results\'];
addpath(results_parentdir);
 
 
%% load image data
load(['..\data\stemcell\','stemcell_all.mat']);
%load('\\IN-CSCI-H40452\Users\mdundar\Desktop\Data\FlowCapINature\FlowCAP-I\Data\FCM\csv\Lymph\CSV\stemcell_all.mat')
ug=unique(G_all);
ng=length(ug);
s_range=1:30;
for rep=1:10
macf1 = zeros(1,1);
micf1=[];
for datai=1:4%length(s_range)
in=G_all==ug(s_range(datai));
X=X_all(in,:);
Y=Y_all(in);
X= igmm_normalize(X,20,false);
    prefix = char(strcat(results_parentdir,'/Stem/'));
    mkdir([prefix,'\plots\']);
    %X=igmm_normalize(X,32,false);
    
    
    d=size(X,2);
    k0=0.1;
    ki=1;
    m=150*d+2;
    mu0=mean(X,1);
    Psi=(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
    alp=1; gam=1;


    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(prefix,X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,'.matrix'));
    pripath=char(strcat(prefix,'_NIWprior.matrix'));
    params=char(strcat(prefix,'_params.matrix'));
    
    %writeMat(data,X,'double');

    burn_in='1000';
    num_sweeps = '1500';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['igmm.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',prefix,' 20'];
    tic;
    
    
    
    system(cmd);
    slabels=readMat(char(strcat(prefix,'Labels.matrix')))+1;
    elapsed(datai) = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    %sublabels=readMat(char(strcat(prefix ,'Sublabels.matrix')))+1;
    %slabels(isnan(slabels))=0;
    labels = align_labels(slabels');
    
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1(datai) = table2array(f1s(1,1))
    micf1(datai) = table2array(f1s(1,2))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),2,labels)
    %plotHierarchicalData(X,alabels',labels');
end
macsf1(rep)=mean(macf1)
elapses(rep)=mean(elapsed)
mean(micf1)
end