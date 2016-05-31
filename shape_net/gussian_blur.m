base_dir = '/home/xpeng/project/nips2016/results_bb/ori';
target_dir = '/home/xpeng/project/nips2016/results_bb/gussian_noise';

dir_list = dir(base_dir);
sigma = 1;
for i = 3:length(dir_list)
	image_list = dir([base_dir '/' dir_list(i).name '/*.jpg']);
	mkdir_if_missing([target_dir '/' dir_list(i).name]);
	for j =1:length(image_list) 
		im = imread([base_dir '/' dir_list(i).name '/' image_list(j).name]);
		%im_blur = imgaussfilt(im, sigma);
		im_blur = imnoise(im_blur, 'gaussian', 0, 0.001);
		imwrite(im_blur, [target_dir '/' dir_list(i).name '/' image_list(j).name]);
	end
end
