experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('..\data\letter\readData.m')
prefix = char(strcat(folder,'/letter/'));
mkdir([prefix,'\plots\']);
X=igmm_normalize(X,20,true);

    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    Psi=1*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
    alp=1; gam=1;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(prefix,X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,'.matrix'));
    pripath=char(strcat(prefix,'_NIWprior.matrix'));
    params=char(strcat(prefix,'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '2000';
    burn_in='1600';
    step='10';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2s.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',prefix];
    tic;
    system(cmd);
    elapsed = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char(strcat(prefix ,'Labels.matrix')))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    labels = align_labels(slabels');
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1 = table2array(f1s(1,1))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),10,labels);


fprintf(1,'%.3f\n',mean(macf1))
fprintf(1,'%.1f\n',elapsed)