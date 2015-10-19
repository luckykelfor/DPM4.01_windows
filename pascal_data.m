function [pos, neg] = pascal_data(cls, flippedpos, year)

% [pos, neg] = pascal_data(cls)
% Get training data from the PASCAL dataset.

setVOCyear = year;
globals; 
pascal_init;

if nargin < 2
  flippedpos = false;
end

try
  load([cachedir cls '_train_' year]);%如果已经保存了直接load(pos neg数据)
catch
%   % positive examples from train+val
%   ids = textread(sprintf(VOCopts.imgsetpath, 'trainval'), '%s');
%   pos = [];
%   numpos = 0;
%   for i = 1:length(ids);
%     fprintf('%s: parsing positives: %d/%d\n', cls, i, length(ids));
%     rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));%读取每个正样本的标注(xml文件中)
%     clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');%正则表达式找到每张样本中的标注方框
%     % skip difficult examples
%     diff = [rec.objects(clsinds).difficult];
%     clsinds(diff) = [];
%     for j = clsinds(:)'
%       numpos = numpos+1;
%       pos(numpos).im = [VOCopts.datadir rec.imgname];
%       bbox = rec.objects(j).bbox;
%       pos(numpos).x1 = bbox(1);
%       pos(numpos).y1 = bbox(2);
%       pos(numpos).x2 = bbox(3);
%       pos(numpos).y2 = bbox(4);
%       pos(numpos).flip = false;
%       pos(numpos).trunc = rec.objects(j).truncated;
%       if flippedpos %是否水平翻转
%         oldx1 = bbox(1);
%         oldx2 = bbox(3);
%         bbox(1) = rec.imgsize(1) - oldx2 + 1;
%         bbox(3) = rec.imgsize(1) - oldx1 + 1;
%         numpos = numpos+1;
%         pos(numpos).im = [VOCopts.datadir rec.imgname];
%         pos(numpos).x1 = bbox(1);
%         pos(numpos).y1 = bbox(2);
%         pos(numpos).x2 = bbox(3);
%         pos(numpos).y2 = bbox(4);
%         pos(numpos).flip = true;
%         pos(numpos).trunc = rec.objects(j).truncated;
%       end
%     end
%   end

%或者自己写一个txt格式的标注信息文件来读取
    pos = []; % 存储正样本目标信息的数组，每个元素是一个结构，{im, x1, y1, x2, y2}
    numpos = 0; % 正样本目标个数(一个图片中可能含有多个正样本目标)
    
    %假设标注的文件为inriaPersonPos.txt是从Inria人体数据集获得的50个正样本的标注文件，格式为[x1 y1 x2 y2 RelativePath]
    [a,b,c,d,p] = textread('MyAnnotation.txt','%d %d %d %d %s'); % 注意：读取后p的类型时50*1的cell类型
    
    % 遍历训练图片文件名数组ids
    for i = 1:length(a);
        if mod(i,10)==0
            fprintf('%s: parsing positives: %d/%d\n', cls, i, length(a));
        end;
        numpos = numpos+1; % 正样本目标个数
        pos(numpos).im = p{numpos}; % 引用cell单元时要用{},引用矩阵单元时用()
        pos(numpos).x1 = a(numpos);
        pos(numpos).y1 = b(numpos);
        pos(numpos).x2 = c(numpos);
        pos(numpos).y2 = d(numpos);
        pos(numpos).flip = false;%不进行水平翻转
    end

  % negative examples from train (this seems enough!)
  ids = textread(sprintf(VOCopts.imgsetpath, 'train'), '%s');%从整个训练集上查找负样本
  neg = [];
  numneg = 0;
  addpath('./VOCdevkit/VOCcode');
  for i = 1:length(ids);
    fprintf('%s: parsing negatives: %d/%d\n', cls, i, length(ids));
    rec = PASreadrecord(sprintf(VOCopts.annopath, ids{i}));
    clsinds = strmatch(cls, {rec.objects(:).class}, 'exact');
    if length(clsinds) == 0%如果某个样本不是包含某个类的，则clsinds为空，说明随便都是负样本
      numneg = numneg+1;
      neg(numneg).im = [VOCopts.datadir rec.imgname];
      neg(numneg).flip = false;
    end
  end
  
  save([cachedir cls '_train_' year], 'pos', 'neg');
end  
