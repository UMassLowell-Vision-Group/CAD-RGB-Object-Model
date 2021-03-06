function res = rcnn_test( suffix)
% res = rcnn_test(imdb, suffix)
%   Compute test results using the trained rcnn_model on the
%   image database specified by imdb. Results are saved
%   with an optional suffix.

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2014, Ross Girshick
% 
% This file is part of the R-CNN code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------
%                     config
%----------------------------------------------------------
feat_dir = './feat_cache/alex_shape_random_texture_gussian_1_noise_4k/voc_2007_test/';
get_max = 8;
max_per_image = 100;
imdb=imdb_from_voc('./dataset/VOCdevkit2007', 'test', '2007');
%----------------------------------------------------------



conf = rcnn_config('sub_dir', imdb.name);
image_ids = imdb.image_ids;

% assume they are all the same
%feat_opts = rcnn_model.training_opts;
num_classes = length(imdb.classes);

if ~exist('suffix', 'var') || isempty(suffix)
  suffix = '';
else
  suffix = ['_' suffix];
end

try
  aboxes = cell(num_classes, 1);
  for i = 1:num_classes
    load([conf.cache_dir imdb.classes{i} '_boxes_' imdb.name suffix]);
    aboxes{i} = boxes;
  end
catch
  aboxes = cell(num_classes, 1);
  box_inds = cell(num_classes, 1);
  for i = 1:num_classes
    aboxes{i} = cell(length(image_ids), 1);
    box_inds{i} = cell(length(image_ids), 1);
  end

  % heuristic that yields at most 100k pre-NMS boxes
  % per 2500 images
  max_per_set = ceil(100000/2500)*length(image_ids);
 
  top_scores = cell(num_classes, 1);
  thresh = -inf(num_classes, 1);
  box_counts = zeros(num_classes, 1);

  
  folds{1} = 1:length(image_ids);
  

  count = 0;
  for f = 1:length(folds) %1:1
    for i = folds{f}      %1:4952
      count = count + 1;
      fprintf('%s: test (%s) %d/%d\n', procid(), imdb.name, count, length(image_ids));
     
	d = load([feat_dir image_ids{i} ]);
	
	max_per_image = min(max_per_image, size(d.rpbox, 1));
	len = min(get_max, size(d.rpbox, 1));
	d.rpbox = d.rpbox(1:len,:);
	%d.feat = d.feat(1:len,2:21);
	d.feat = d.feat(1:len,:);
	d.boxes = d.rpbox(:,1:4);
	
	zs = d.feat;
	%[v,ind] = max(zs);
	%zs=zs-zs;
	%zs(ind) = v;
	
      	for j = 1:num_classes
        boxes = d.boxes;
        z = zs(:,j);
        I = find(z > thresh(j));
        boxes = boxes(I,:);
        scores = z(I);
        aboxes{j}{i} = cat(2, single(boxes), single(scores));
        [~, ord] = sort(scores, 'descend');
        ord = ord(1:min(length(ord), max_per_image));
        aboxes{j}{i} = aboxes{j}{i}(ord, :);
        box_inds{j}{i} = I(ord);

        box_counts(j) = box_counts(j) + length(ord);
        top_scores{j} = cat(1, top_scores{j}, scores(ord));
        top_scores{j} = sort(top_scores{j}, 'descend');
        if box_counts(j) > max_per_set
          top_scores{j}(max_per_set+1:end) = [];
          thresh(j) = top_scores{j}(end);
        end
      end
    end
  end

  for i = 1:num_classes
    % go back through and prune out detections below the found threshold
    for j = 1:length(image_ids)
      if ~isempty(aboxes{i}{j})
        I = find(aboxes{i}{j}(:,end) < thresh(i));
        aboxes{i}{j}(I,:) = [];
        box_inds{i}{j}(I,:) = [];
      end
    end

    save_file = [conf.cache_dir imdb.classes{i} '_boxes_' imdb.name suffix];
    boxes = aboxes{i};
    inds = box_inds{i};
    save(save_file, 'boxes', 'inds');
    clear boxes inds;
  end
end

% ------------------------------------------------------------------------
% Peform AP evaluation
% ------------------------------------------------------------------------
for model_ind = 1:num_classes
  cls = imdb.classes{model_ind};
  res(model_ind) = imdb.eval_func(cls, aboxes{model_ind}, imdb, suffix);
end

fprintf('\n~~~~~~~~~~~~~~~~~~~~\n');
fprintf('Results:\n');
aps = [res(:).ap]';
disp(aps);
disp(mean(aps));
fprintf('~~~~~~~~~~~~~~~~~~~~\n');
