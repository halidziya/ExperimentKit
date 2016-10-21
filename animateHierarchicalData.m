function animateHierarchicalData(X,slabels,labels)
filename = 'lastanim.gif';
for i=2:size(labels,1)
    plotHierarchicalData(X,slabels,labels,i)
    mus=[];
    for j=1:max(slabels(i,:))
        mus(j,:) = mean(X(slabels(i,:)==j,:),1);
    end
    scatter(mus(:,1),mus(:,2),30,[0,0,0],'*');
    scatter(mus(:,1),mus(:,2),50,[0,0,0],'o');
    scatter(mus(:,1),mus(:,2),30,[0,0,0]);
    if (size(mus,1)>2)
        voronoi(mus(:,1),mus(:,2))
    end
    drawnow limitrate
    pause(1);
%     frame = getframe(1);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%       if i == 1;
%       imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%      else
%       imwrite(imind,cm,filename,'gif','WriteMode','append');
%       end
      
end
end
