% Set up global variables used throughout the code

% setup svm mex for context rescoring (if it's installed)
if exist('./svm_mex601') > 0
  addpath svm_mex601/bin;
  addpath svm_mex601/matlab;
end

% dataset to use
if exist('setVOCyear') == 1
  VOCyear = setVOCyear;
  clear('setVOCyear');
else
  VOCyear = '2011';
end

% directory for caching models, intermediate data, and results
cachedir = '.\tmp\YOURPATH\';

if exist(cachedir) == 0
  system(['md' cachedir]);
  if exist([cachedir 'learnlog\']) == 0
    system(['md' cachedir 'learnlog/']);
  end
end

% directory for LARGE temporary files created during training
tmpdir = '.\temp\';

if exist(tmpdir) == 0
  system(['md' tmpdir]);
end

% should the tmpdir be cleaned after training a model?
cleantmpdir = true;

% directory with PASCAL VOC development kit and dataset
 VOCdevkit = '.\VOCdevkit\';
