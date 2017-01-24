experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('../data/seeds/readData.m')
prefix = char(strcat(folder,'/seeds/i'));
mkdir([prefix,'/plots/']);
X=igmm_normalize(X,20,true);

    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    Psi=1*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
%     for i=1:10
%         Psi = Psi + cov(X(klabs==i,:));
%     end
    
    alp=0.1; gam=1;

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
    %labels = kmeans(X,length(unique(Y(Y~=0))));
    system(cmd);
    elapsed = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char(strcat(prefix,'Labels.matrix')))+1;
    %sublabels=readMat(char(strcat(prefix ,'Sublabels.matrix')))+1;
    slabels(isnan(slabels))=0;
    labels = align_labels(slabels');
    
    %slabels=readMat(char(strcat(prefix ,'.matrix.superlabels')))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    %alabels = align_labels(slabels');
    % gmd=gmdistribution.fit(X,26,'Regularize',0.1)
    % evaluationTable(Y,gmd.cluster(X))
    
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1 = table2array(f1s(1,1))
    micf1 = table2array(f1s(1,2))
    clf;
    colormap summer;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,Y);
    
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),10,labels);

fprintf(1,'%.3f\n',mean(macf1));
fprintf(1,'%.2f\n',elapsed);

% f1s = []
% obf=[]
% for i=1:size(slabels,1)
%     obf(i) = 0
%     for j=1:size(unique(slabels(i,:)),1)
%         at = fitcsvm(X,slabels(i,:)==j)
%         obf(i) = obf(i)  + at.ConvergenceInfo.Objective
%     end
%     %obf(i) = obf(i)/j
%     at = evaluationTable(Y(Y~=0),slabels(i,:))
%     f1s(i)=table2array(at(1,1))
% end
%  plot(obf,f1s,'.')
