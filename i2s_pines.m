experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('..\data\pines\readData.m')
prefix = char(strcat(folder,'/Indian/i'));
mkdir([prefix,'\plots\']);
X=igmm_normalize(X,12,true);

    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    klabs = kmeans(X,10);
    Psi=1*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
%     for i=1:10
%         Psi = Psi + cov(X(klabs==i,:));
%     end
    
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
    cmd = ['i2gmm.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
    tic;
    
    
    %labels = kmeans(X,length(unique(Y(Y~=0))));
    system(cmd);
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char('10Labels.matrix'))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    slabels(isnan(slabels))=1
    labels = align_labels(slabels');
    
    
    elapsed = toc;

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

fprintf(1,'%.3f\n',mean(macf1));
fprintf(1,'%.2f\n',elapsed);