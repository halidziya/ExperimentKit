#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 15 19:16:55 2016

@author: halidziya
"""

from scipy.io import loadmat
import scipy.stats
import os
import numpy as np
from FastMat import writeMat,readMat
import subprocess
from sklearn.metrics import confusion_matrix
from scipy.cluster.vq import whiten
from sklearn.metrics import f1_score
os.chdir('/home/halidziya/Desktop/HIGMM/ExperimentKit')

experiments='experiments/';
folder = experiments + 'parallel' 
#os.mkdir(folder)
macf1=[];
micf1=[];
loadmat("../data/ndd/ndd_all.mat")
matdict = loadmat("../data/ndd/ndd_all.mat")
prefix = folder+ '/NDD/' 
#os.mkdir(prefix)
X_all = matdict["X_all"]
Y_all = matdict["Y_all"]
G_all = matdict["G_all"].flatten()
for datai in range(1,31):
    X=whiten(X_all[G_all==datai,:])
    Y=Y_all[G_all==datai]

    
    
    d=X.shape[1]
    k0=0.05
    ki=0.4
    m=d+2
    mu0=np.mean(X,0)
    Psi=(m-d-1)*np.eye(d);
    alp=1; gam=1;

    data=prefix+str(datai)+'.matrix';
    psipath=prefix+str(datai)+'_psi.matrix';
    meanpath=prefix+str(datai)+'_mean.matrix';
    params=prefix+str(datai)+'_params.matrix';
    writeMat(data,X)
    writeMat(psipath,Psi)
    writeMat(meanpath,np.matrix(mu0))
    writeMat(params,np.matrix((k0,ki,m,alp,gam)))

    num_sweeps = '2000';
    burn_in='1600';
    step='10';
    #cmd = ['./i2slice',"", data , ' ' ,  meanpath ,  ' ' , psipath , ' ' , params , ' ' , num_sweeps , ' ' ,  burn_in , ' '  , step]
    subprocess.call(['./i2slice', data])
    
    slabels = readMat(data+".superlabels")
    labels  = scipy.stats.mode(slabels)[0]
    confmat = confusion_matrix(Y,labels.transpose())
    labels = np.argmax(confmat,axis=0)[labels.astype('int')]
    f1_score(Y,labels)
    
    