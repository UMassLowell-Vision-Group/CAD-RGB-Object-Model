

fid= fopen('train_random_texture_gussian_1_noise.txt', 'w');
base_dir = '/home/xpeng/project/nips2016/results_bb/gussian_1_noise';
dir_list = dir([base_dir ]);
for i = 3:22
	fprintf('%s\n', dir_list(i).name);
	file_list = dir([base_dir '/' dir_list(i).name '/*.jpg']);
	for j = 1:3:length(file_list)
		fprintf('%d %d\n', i, j);
		fprintf(fid, '%s %d\n',[ base_dir '/' dir_list(i).name '/' file_list(j).name], i-3 );
		%im = imread([base_dir '/' dir_list(i).name '/' file_list(j).name]);
		%imwrite(im, [base_dir '/z_all/' file_list(j).name]);
	end
end

fclose(fid);
