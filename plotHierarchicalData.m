function plotHierarchicalData(X,slabels,labels,sampleindex)
    colormap(linspecer(max(max(labels))+1));
    if (~exist('sampleindex','var'))
        sampleindex = size(labels,1);
    end
    slabels = slabels(sampleindex,:)';
    labels = labels(sampleindex,:)';
    %labels = align_labels(labels');
    %slabels = align_labels(slabels');
    cla;
    scatter(X(:,1),X(:,2),10,slabels);
    covs=[];
    mus = [];
    for i=1:max(labels)
        mus(i,:) = mean(X(labels==i,1:2),1);
        if (sum(labels==i) > (size(X,2)+1)) 
            covs(i,:,:) = cov(X(labels==i,1:2));
            plot_gaussian_ellipsoid(mean(X(labels==i,1:2)),squeeze(covs(i,:,:)),'--',[0.4 0.4 0.4],2,1)
        else
            covs(i,:,:) = zeros(2);
        end
    end

    for i=1:max(slabels)
        if (sum(slabels==i) > (size(X,2)+1))
        plot_gaussian_ellipsoid(mean(X(slabels==i,1:2),1),cov(X(slabels==i,1:2)),'-',[0 0 0],2,2)
        end
    end
    lmap = unique([slabels labels],'rows');
    for i=1:max(slabels)
        if (sum(slabels==i) > (size(X,2)))
            try
                plot_gaussian_ellipsoid(mean(X(slabels==i,1:2)),squeeze(mean(covs(lmap(lmap(:,1)==i,2),:,:),1)),'-',[0.4 0.2 0.2],2,2)
            catch 
                fprintf(1,'Skipped')
            end
        end
    end
    axis([min(X(:,1))-0.01 max(X(:,1))+0.01 min(X(:,2))-0.01 max(X(:,2))+0.01])
end