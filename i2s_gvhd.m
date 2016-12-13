experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);


metadata = [];
for trial=1:200  
macf1=[];
micf1=[];
f1s = {};
d =6;
k0=rand()*.5;
ki=rand()*.5+k0;
%m=150*d;
m=150*d+2;%398;%d+2+randi(100,1)*d;

%Psi=diag([0.6 0.6 0.3 0.3 0.3 0.3])*(m-d-1);
%Psi=(m-d-1)*diag([5*rand(d,1)]);
%Psi=(m-d-1)*diag([3.66 , 3.65, 4.79, 0.229, 2.12,0.0451]);
Psi = (m-d-1)*1*eye(d)*0.4;
alp=1; gam=1;
parfor datai=1:12

    filename = ['..\data\GVHD\FCM\' num2str(datai,'%.3d') '.csv']
    labelname = ['..\data\GVHD\labels\' num2str(datai,'%.3d') '.csv']
    X=dlmread(filename,',',2);
    
    Y=dlmread(labelname,',',2);
    prefix = char(strcat(folder,'/GVHD/'));
    mkdir([prefix,'\plots\']);
    X=igmm_normalize(X,32,false);
    mu0=mean(X,1);
    


    fprintf(1,'Writing files...\n');
    i2gmm_createBinaryFiles(char(strcat(prefix  , num2str(datai))),X,Psi,mu0,m,k0,ki,alp,gam);

    
    data=char(strcat(prefix,num2str(datai),'.matrix'));
    psipath=char(strcat(prefix,num2str(datai),'_psi.matrix'));
    meanpath=char(strcat(prefix,num2str(datai),'_mean.matrix'));
    params=char(strcat(prefix,num2str(datai),'_params.matrix'));
    
    %writeMat(data,X,'double');

    num_sweeps = '1600';
    burn_in='1200';
    step='10';
    fprintf(1,'I2GMM is running...\n');
    cmd = ['i2s.exe ',data,' ',meanpath,' ',psipath,' ',params,' ',num_sweeps,' ', burn_in,' ',step];
    tic;
    system(cmd);
    elapsed(datai) = toc;

    slabels=readMat(char(strcat(prefix ,num2str(datai),'.matrix.superlabels')))+1;
    labels=readMat(char(strcat(prefix ,num2str(datai),'.matrix.labels')))+1;
    alabels = align_labels(slabels');
    f1s{datai}=evaluationTable(Y(Y~=0),alabels(Y~=0))
    macf1(datai) = table2array(f1s{datai}(1,1))
    micf1(datai) = table2array(f1s{datai}(1,2))
    clf;
    subplot(2,1,1);
    scatter(X(:,1),X(:,2),10,1+Y);
    colormap hsv;
    subplot(2,1,2);
    plotHierarchicalData(X,alabels',alabels');
end
metadata(trial,:) = [k0,ki,m,diag(Psi)'/(m-d-1),mean(macf1),mean(micf1),mean(elapsed)];
end