experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
macf1=[];
micf1=[];
parfor datai=1:30
    filename = ['..\data\Lymph\data\' num2str(datai,'%.3d') '.csv']
    labelname = ['..\data\Lymph\labels\' num2str(datai,'%.3d') '.csv']
    X=dlmread(filename,',',2);
    Y=dlmread(labelname,',',2);
    prefix = char(strcat(folder,'/Lymph/'));
    mkdir([prefix,'\plots\']);
    X=igmm_normalize(X,20,false);
    
    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    
    Psi=1*(m-d-1)*eye(d);%*diag([1 1 0.1 0.1 0.1]);
%     for i=1:10
%         Psi = Psi + cov(X(klabs==i,:));
%     end
    
    alp=1; gam=1;

    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(char(strcat(prefix  , num2str(datai))),X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,num2str(datai),'.matrix'));
    pripath=char(strcat(prefix,num2str(datai),'_NIWprior.matrix'));
    params=char(strcat(prefix,num2str(datai),'_params.matrix'));
    
    %writeMat(data,X,'double');
     tic;
    num_sweeps = '1000';
    burn_in='600';
    step='10';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2s.exe ',data,' ',pripath,' ',params,' ',num_sweeps,' ', burn_in,' ',strcat(prefix,num2str(datai))];

    system(cmd);

    slabels=readMat(char(strcat(prefix ,num2str(datai),'Labels.matrix')))+1;
    %slabels(1,:) = [];
    %labels=readMat(char(strcat(prefix ,num2str(datai),'.matrix.labels')))+1;
    alabels = align_labels(slabels');
    elapsed(datai) = toc;
%     alabels = kmeans(X,length(unique(Y)));

%     tic;
%     gmd=gmdistribution.fit(X,length(unique(Y)),'Regularize',0.01);
%     elapsed(datai)= toc;
    %f1s=evaluationTable(Y,gmd.cluster(X));
    
    f1s=evaluationTable(Y(Y~=0),alabels(Y~=0))
    macf1(datai) = table2array(f1s(1,1))
    micf1(datai) = table2array(f1s(1,2))
    

    
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    %plotHierarchicalData(X,alabels',alabels');
end
mean(macf1)
mean(micf1)

fprintf(1,'%.3f\n',mean(macf1))
fprintf(1,'%.1f\n',mean(elapsed))