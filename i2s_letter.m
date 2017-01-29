experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
run('..\data\letter\readData.m')

X=igmm_normalize(X,20,true);

for rep=1:10
    prefix = char(strcat(folder,'/letter/' , num2str(rep) ));
    mkdir([prefix,'\plots\']);

    d=size(X,2);
    k0=0.05;
    ki=0.5;
    m=d+2;
    mu0=mean(X,1);
    Psi=1*(m-d-1)*eye(d);%/(150/(d*log(d)))%*diag([1 1 0.1 0.1 0.1]);
    alp=1; gam=1;

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
    elapsed(rep) = toc;
    %[dishes rests likelihood labels]=i2gmm_readOutput('./');
    slabels=readMat(char(strcat(prefix ,'Labels.matrix')))+1;
    %labels=readMat(char(strcat(prefix ,'.matrix.labels')))+1;
    labels = align_labels(slabels');
    f1s=evaluationTable(Y(Y~=0),labels(Y~=0))
    macf1(rep) = table2array(f1s(1,1))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    scatter(X(:,1),X(:,2),10,labels);

end
%fprintf(1,'%s\n',cmd)
fprintf(1,'%.3f\n',mean(macf1))
fprintf(1,'%.3f\n',std(macf1))
fprintf(1,'%.1f\n',mean(elapsed))