#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import struct
import numpy as np
"""
Created on Thu Dec 15 23:40:16 2016

@author: halidziya
"""

#Binary read-write
def readMat(filename):
    with open(filename,"rb") as fp:
        r = struct.unpack('I', bytearray(fp.read(4)))[0]
        m = struct.unpack('I', bytearray(fp.read(4)))[0]
        print(r)
        print(m)
        x = np.zeros((r,m))
        for i in range(0,r):
            for j in range(0,m):
                x[i,j] =  struct.unpack('d',bytearray(fp.read(8)))[0]
    return x
    
def writeMat(filename,x):
    with open(filename,"wb") as fp:
        (r,m) = np.array(x.shape).astype('int32')
        fp.write( struct.pack('i', r))
        fp.write( struct.pack('i', m))
        for i in range(0,r):
            for j in range(0,m):
                fp.write(struct.pack('d', x[i,j]))