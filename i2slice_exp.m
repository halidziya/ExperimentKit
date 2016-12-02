experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
[files names] =  igmm_datasets('..\data'); % Traverse in folder
elapsed=[];
for datai=1:length(names)

    prefix = char(strcat(folder,'/',names(datai),'/'));
    mkdir([prefix,'\plots\']);
    run(files{datai});
    X=igmm_normalize(X,20);
    
    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    s=150/d/log(d);
    mu0=mean(X,1);
    Psi=(m-d-1)*diag(diag(cov(X)))/s;
    alp=1; gam=1;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(char(strcat(prefix  , names(datai))),X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,names(datai),'.matrix'));
    psipath=char(strcat(prefix,names(datai),'_psi.matrix'));
    meanpath=char(strcat(prefix,names(datai),'_mean.matrix'));
    params=char(strcat(prefix,names(datai),'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '1500  ';
    burn_in='1440';
    step='20';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2gmmh.exe ',data];
    tic;
    system(cmd);
    elapsed(datai) = toc;

    slabels=readMat('Labels.matrix');
    %slabels=readMat(char(strcat(prefix ,names(datai),'.matrix.superlabels')))+1;
    %labels=readMat(char(strcat(prefix ,names(datai),'.matrix.labels')))+1;
    alabels = align_labels(slabels');
    f1s=evaluationTable(Y(Y~=0),alabels(Y~=0))
    plotHierarchicalData(X,alabels',alabels');
    %keyboard;
end