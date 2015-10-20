function demo()

%load('person_final');
load('./INRIA/inriaperson_final.mat');
ids = textread('test.txt','%s');
for i =18:length(ids)
   test(ids{i}, model);
end 
 
test('000061.jpg', model);

load('VOC2007/bicycle_final');
test('000084.jpg', model);

function test(name, model)
cls = model.class;
% load and display image
im = imread(name);
clf;
image(im);
axis equal; 
axis on;
disp('input image');   
disp('press any key to continue'); pause;
disp('continuing...');

% load and display model
visualizemodel(model, 1:2:length(model.rules{model.start}));
disp([cls ' model visualization']);
disp('press any key to continue'); pause;
disp('continuing...');

% detect objects
[dets, boxes] = imgdetect(im, model, model.thresh);
top = nms(dets, 0.5);
clf;
if(size(boxes,1)~=0)
    showboxes(im, reduceboxes(model, boxes(top,:)));
    disp('detections');
    disp('press any key to continue'); pause;

    % get bounding boxes
    bbox = bboxpred_get(model.bboxpred, dets, reduceboxes(model, boxes));
    bbox = clipboxes(im, bbox);
    top = nms(bbox, 0.5);
    clf;
    showboxes(im, bbox(top,:));
    disp('bounding boxes');
    disp('press any key to continue'); pause;

else
    disp('No detection, press any key to continue'); pause;
end

