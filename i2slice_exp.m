experiments='experiments/';
folder = strcat(experiments,'parallel');
igmm_mkdir(folder);
[files names] =  igmm_datasets('..\..\..\data'); % Traverse in folder

for datai=1:length(names)

    prefix = char(strcat(folder,'/',names(datai),'/'));
    mkdir([prefix,'\plots\']);
    run(files{datai});
    X=igmm_normalize(X,10);
    
    num_sweeps = '5000';
    data=char(strcat(prefix,names(datai),'.matrix'));
    prior=char(strcat(prefix,names(datai),'_prior.matrix'));
    params=char(strcat(prefix,names(datai),'_params.matrix'));
    
    writeMat(data,X,'double');
    
    cmd = ['dpsl.exe ',data];
    tic;
    system(cmd);
    toc;

    slabels=readMat(char(strcat(prefix ,names(datai),'.matrix.superlabels')))+1;
    labels=readMat(char(strcat(prefix ,names(datai),'.matrix.labels')))+1;
    alabels = align_labels(labels((end-5):end,:)');
    f1s=evaluationTable(Y(Y~=0),alabels(Y~=0))
    
    plotHierarchicalData(X,alabels',alabels')
    

end