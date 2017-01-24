experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
if (~exist('Xorg','var'))
    load('..\data\flowcap3\flowcapIII_all.mat')
    Xorg=X;
    Yorg=Y;
    Y=Y(LA==1);
    X=igmm_normalize(Xorg(LA==1,:),20,true);
end

prefix = char(strcat(folder,'/Flowcap/i'));
mkdir([prefix,'\plots\']);


    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    Psi=10*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
%     for i=1:10
%         Psi = Psi + cov(X(klabs==i,:));
%     end
    
    alp=0.0001; gam=0.0001;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(prefix,X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,'.matrix'));
    pripath=char(strcat(prefix,'_NIWprior.matrix'));
    params=char(strcat(prefix,'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '2000';
    burn_in='1600';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2s.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',prefix,' 20'];
    tic;
     system(cmd);
    elapsed=toc;
    
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char(strcat(prefix,'Labels.matrix')))+1;
    %sublabels=readMat(char(strcat(prefix ,'Sublabels.matrix')))+1;
    slabels(isnan(slabels))=0;
    labels = align_labels(slabels');
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
