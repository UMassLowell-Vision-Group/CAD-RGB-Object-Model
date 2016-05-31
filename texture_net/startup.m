function startup()
	addpath('./imdb');
	addpath('./utils');
	addpath('./external/edges');
	addpath('./external/edges/toolbox/channels');
	addpath('./external/edges/toolbox/detector');
	addpath('./external/edges/toolbox/images');
	
	%addpath('./external/caffe/matlab/+caffe/imagenet');
	addpath('./external/caffe/matlab');
    addpath('./extract_feature');
    addpath('./external/caffe/matlab/+caffe/private');
    addpath('./purify');
    addpath('./results_bbox');
	addpath('./feat_cache');
end
