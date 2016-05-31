function tx_feature(opts,imdb)

%This function will call feature_extractor to extract the CNN feature.
	%Initialize caffe setting 
	boxes_num  = 1024;
	output_dir = opts.output_dir;
	net_model = opts.net_model;
	net_weights = opts.net_weights;
	start_at = opts.start_at;
	end_at = opts.end_at;
	
	caffe.set_mode_gpu();
	caffe.set_device(opts.GPU_ID);

	phase = 'test';

	batch_size = opts.batch_size;
	%fprintf('%s\n', net_weights);
	if ~exist(net_weights, 'file')
		error('Caffe Net not found!\n');
	end

	net = caffe.Net(net_model, net_weights, phase);
 
	%Load imdb and region proposals
	%imdb=imdb_from_voc('./dataset/VOCdevkit2007', 'test', '2007');
	try
		rpbox_path = fullfile('external', 'edges', 'cache','rp_test_2007.mat');
		rpbox_ld = load(rpbox_path);
		rpboxes = rpbox_ld.rpboxes;
	catch
		fprintf('Please first run region proposal method to generate the bounding boxes\n');
	end
	
	total_time = 0;


	mkdir_if_missing(output_dir);
	conf = rcnn_config();
	timestamp = datestr(datevec(now()), 'dd.mmm.yyyy:HH.MM.SS');
	diary_file = [conf.cache_dir 'tx_extractor_' timestamp '.txt'];
	diary(diary_file);


	%for i = 1:2500
	for i = start_at : end_at
		fprintf('%s: cache features: %d/%d\n', procid(), i, length(imdb.image_ids));
		save_file = [output_dir '/' imdb.image_ids{i} '.mat'];
		if exist(save_file, 'file') ~= 0
			fprintf(' [already exists]\n');
			continue;
		end
		th =tic;
		image = imread(imdb.image_at(i));
		rpbox = rpboxes(i).bbox;
		% convert rpbox from [x, y , w, h, score] format to [x1, y1, x2, y2] format;
		
		if size(rpbox, 1) >boxes_num;
			rpbox = rpbox(1:boxes_num, :);
		end
		rpbox(:, 3) = rpbox(:, 3) + rpbox(:, 1);
		rpbox(:, 4) = rpbox(:, 4) + rpbox(:, 2);
		d=struct;
		d.rpbox = rpbox;

		rpbox = rpbox(:, 1:4);		

		% prepare image batches 
		[batches, batch_padding] = rcnn_extract_regions(image, rpbox, opts.input_size, batch_size);
		feat = [];
		curr = 1;
		feat_dim = -1;
		for j = 1:length(batches)
			%fprintf('Before.... \n');
			%size(batches(j))
			f = net.forward(batches(j));

			%fprintf('After .... \n');
			f = f{1};
			f = f(:);
 			% first batch, init feat_dim and feat
  			if j == 1
    				feat_dim = length(f)/batch_size;
    				feat = zeros(size(rpbox, 1), feat_dim, 'single');
  			end

  			f = reshape(f, [feat_dim batch_size]);

  			% last batch, trim f to size
  			if j == length(batches)
    			if batch_padding > 0
      				f = f(:, 1:end-batch_padding);
    			end
  			end
			
  			feat(curr:curr+size(f,2)-1,:) = f';
			d.feat =feat;
  			curr = curr + batch_size;
			save(save_file, '-struct', 'd');

		end
		
		fprintf(' [features: %.3fs]\n', toc(th));
	end
	
end




