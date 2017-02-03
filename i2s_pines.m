experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('..\data\pines\readData.m')
prefix = char(strcat(folder,'/Indian/pines'));
mkdir([prefix,'\plots\']);
Xorg = X;
X=igmm_normalize(X,20,true);


for rep=1:10
    
    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    Psi=eye(d);%*diag([1 1 0.1 0.1 0.1]);
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

    
    burn_in='1000';
    num_sweeps = '1500';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['igmm.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',prefix,' 20'];
    tic;
    
    
    %labels = kmeans(X,length(unique(Y(Y~=0))));
    %system(cmd);
    elapsed(rep) = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    %slabels=readMat(char(strcat(prefix,'Labels.matrix')))+1;
    %sublabels=readMat(char(strcat(prefix ,'Sublabels.matrix')))+1;
    %slabels(isnan(slabels))=0;
    %slabels(1,:)=[];
    %labels = align_labels(slabels');
    
    
    

    %slabels=readMat(char(strcat(prefix ,'.matrix.superlabels')))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    %alabels = align_labels(slabels');
    %gmd=gmdistribution.fit(X,length(unique(Y)),'Regularize',0.1)
    %labels = gmd.cluster(X);
    labels = kmeans(X,length(unique(Y)));
    % evaluationTable(Y,gmd.cluster(X))
    
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1(rep) = table2array(f1s(1,1))
    micf1 = table2array(f1s(1,2))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),10,labels);
end
fprintf(1,'%s\n',cmd)
fprintf(1,'%.3f\n',mean(macf1))
fprintf(1,'%.3f\n',std(macf1))
fprintf(1,'%.1f\n',mean(elapsed))
fprintf(1,'%.1f\n',std(elapsed))