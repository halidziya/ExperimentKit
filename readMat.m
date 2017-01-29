function mat=readMat(filename)
    file=fopen(filename);
    if (filename == -1)
       fprintf(1,['Error reading file: ' filename]);
    end
    r = fread(file,1,'int');
    d = fread(file,1,'int');
    mat=fread(file,r*d,'double');
    mat = reshape(mat,d,r)';
    fclose(file);
    % triangle = fread(file,1,'int');
end
