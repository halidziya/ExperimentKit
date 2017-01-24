function i2gmm_createBinaryFiles(filename,X,Psi,mu0,m,kappa,kappai,alpha,gamma) % No labels
    mkdir('data');
    writeMat([ filename '.matrix'],X,'double');
    writeMat([ filename '_params.matrix'],[size(mu0,2) m kappa kappai alpha gamma],'double'); % Aspire format
    writeMat([ filename '_NIWprior.matrix'],[Psi;mu0],'double');
    %writeMat([ filename '_mean.matrix'],mu0,'double');
end