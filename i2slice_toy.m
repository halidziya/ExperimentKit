load('C:\Users\hzyereba\Desktop\I2Slice\I2Slice\data\flower\realflower.mat')
tic
!i2s.exe ..\data\flower\realflower.matrix
toc
labels=readMat('../data/flower/realflower.matrix.labels')+1;
slabels=readMat('../data/flower/realflower.matrix.superlabels')+1;
animateHierarchicalData(X,slabels,labels)
%animateHierarchicalData(X,labels,labels)

