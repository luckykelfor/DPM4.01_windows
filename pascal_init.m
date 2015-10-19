
% initialize the PASCAL development kit 
tmp = pwd;
cd(VOCdevkit);
addpath('.\VOCcode');
cd('VOCcode');
VOCinit;
cd(tmp);
