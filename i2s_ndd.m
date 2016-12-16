load ../data/ndd/ndd_all.mat
experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
macf1=[];
micf1=[];
for datai=1:30
    X=X_all(G_all==datai,:);
    Y=Y_all(G_all==datai);
    prefix = char(strcat(folder,'/NDD/'));
    mkdir([prefix,'\plots\']);
    X=igmm_normalize(X,32,false);
    
    d=size(X,2);
    k0=0.1;
    ki=0.8;
    m=150*d+2;
    mu0=mean(X,1);
    Psi=4*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
    alp=1; gam=1;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(char(strcat(prefix  , num2str(datai))),X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,num2str(datai),'.matrix'));
    psipath=char(strcat(prefix,num2str(datai),'_psi.matrix'));
    meanpath=char(strcat(prefix,num2str(datai),'_mean.matrix'));
    params=char(strcat(prefix,num2str(datai),'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '2000';
    burn_in='1600';
    step='10';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2s.exe ',data,' ',meanpath,' ',psipath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
    tic;
    system(cmd);
    elapsed(datai) = toc;

    slabels=readMat(char(strcat(prefix ,num2str(datai),'.matrix.superlabels')))+1;
    labels=readMat(char(strcat(prefix ,num2str(datai),'.matrix.labels')))+1;
    alabels = align_labels(slabels');
    f1s=evaluationTable(Y(Y~=0),alabels(Y~=0))
    macf1(datai) = table2array(f1s(1,1))
    micf1(datai) = table2array(f1s(1,2))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    plotHierarchicalData(X,alabels',alabels');
end
mean(macf1)
mean(micf1)