clc 
clear 
close all 
load data.mat
addpath("fcn\")
fileNames = {'data_real.txt', 'data_imag.txt'};
filePath = '../SRC/TB/TestFiles/';



[~, o_bin_real] = fim(real(data), 1, 16, 11);
[~, o_bin_imag] = fim(imag(data), 1, 16, 11);
write2file([filePath, fileNames{1}], o_bin_real);
write2file([filePath, fileNames{2}], o_bin_imag);

disp('Write Success!!!')
