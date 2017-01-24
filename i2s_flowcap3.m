experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
load('../data/flowcapIII_all.mat')
prefix = char(strcat(folder,'/Flowcap/i'));
mkdir([prefix,'\plots\']);
%X=X(1:1000000,:);
X=X(LA==1,:);
X=igmm_normalize(X,20,true);

    d=size(X,2);
    k0=0.05;
    ki=0.2;
    m=d+2;
    mu0=mean(X,1);
    Psi=5*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
    alp=0.1; gam=0.1;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(prefix,X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,'.matrix'));
    psipath=char(strcat(prefix,'_psi.matrix'));
    meanpath=char(strcat(prefix,'_mean.matrix'));
    params=char(strcat(prefix,'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '2000';
    burn_in='1600';
    step='10';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['./i2slice ',data,' ',meanpath,' ',psipath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
    tic;
    system(cmd);
    elapsed = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char(strcat(prefix ,'.matrix.superlabels')))+1;
    labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
%    macs=[];
%     for i=1:51; at=evaluationTable(Y(Y~=0),labels(Y~=0,i));macs(i)=table2array(at(1,1));end
%     SC =[ SC ; [likelihood(801:4:1002),macs']];
    slabels(isnan(slabels))=1
     labels = align_labels(slabels');

    %slabels=readMat(char(strcat(prefix ,'.matrix.superlabels')))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    %alabels = align_labels(slabels');
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1 = table2array(f1s(1,1))
    micf1 = table2array(f1s(1,2))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),10,labels);

mean(macf1)
micf1
