
%This function is to extract the features of car and count the label
%for each image. The label will be restored in the result directory
%res: two choice, 'low' for low resolution images, 'high' for high
%   	resolution images

%network: which network to use 
%(1). 'lowNet' : this network is trained on the low Res images.
%(2). 'highNet': this network is trained on the high Res images. 
%(3). 'twoStep': this network is trained on (1).high Res images (2). low Res images.
%(4). 'lowHigh' : this network is trained on (2).low Res images (2). high Res images.

%layer: which layer you want to extract the feature

net_model = './models/AlexNet/deploy_10.prototxt';
net_weights = '/home/xpeng/project/nips2016/models/AlexNet/alex_shape_random_texture_gussian_1_noise_4k.caffemodel';

%local configuration
caffe.set_mode_gpu();
caffe.set_device(1);
phase = 'test';
net = caffe.Net(net_model, net_weights, phase);

[path, cat] = textread('gt_test.txt','%s %d');

feat_cache = zeros(length(cat),1);
feature = zeros(length(cat),20);
for i = 1:length(cat)
	fprintf('%d \ %d', i, length(cat));
	im = imread(path{i});
	input = extractor(im);
	f = net.forward(input);
	f = f{1};
	f = mean(squeeze(f),2)';
	[fc_act, label] =max(f);
	feat_cache(i) = label; 
	feature(i,:) = f; 
end
%save('cat_shape_gussian_noise.mat', 'cat');
save('feat_shape_gussian_noise.mat', 'feat_cache');
save('feture_shape_gussian_noise.mat', 'feature');

%true_positive = find(labels == gt_labels);
%accuracy = length(true_positive)/length(labels);
%fprintf('Accuracy: %f \n', accuracy);



