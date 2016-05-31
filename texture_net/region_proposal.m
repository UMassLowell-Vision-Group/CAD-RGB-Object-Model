function rpboxes = region_proposal(chunk, year)
% Generate Edge Boxes object proposals for give dataset
% 
% The bbs is in [x, y , w, h, score] format
% The generated object proposals for all the images will be stored in 
% './external/edges/cache' 
%  
% Examples for parameter 'chunk': train, trainval, val, test
% Examples for parameter 'year' : 2007, 2012

	imdb = imdb_from_voc(['./dataset/VOCdevkit' year], chunk, year);
	model_path = fullfile('external', 'edges', 'models', 'forest', 'modelBsds.mat');
	model_ld = load(model_path);
	model = model_ld.model;
	model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;
	opts = edgeBoxes;
	opts.alpha = .65;     % step size of sliding window search
	opts.beta  = .75;     % nms threshold for object proposals
	opts.minScore = .01;  % min score of boxes to detect
	opts.maxBoxes = 1e4;  % max number of boxes to detect	
	rpboxes = struct;
	for i =1:length(imdb.image_ids)
	%for i =1:1
		fprintf('Region Proposal for %d th image\n', i);
		img = imread(imdb.image_at(i));
		tic;
		bbs = edgeBoxes(img, model,opts);
		rpboxes(i).bbox = bbs;
		rpboxes(i).name  = [imdb.image_ids{i} '.' imdb.extension] ;
		toc;
	end
	
	cache_path = fullfile('external', 'edges', 'cache');
	mkdir_if_missing(cache_path);
	save([cache_path,'/' 'rp_' chunk '_' year '.mat'], 'rpboxes');


end
